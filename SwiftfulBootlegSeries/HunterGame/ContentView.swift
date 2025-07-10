import SwiftUI
import AVKit

// MARK: - Models and Types
struct Challenge: Identifiable {
    let id: Int
    let icon: String
    var isCompleted: Bool = false
}

enum ChallengeType: Int, CaseIterable {
    case level1 = 1
    case level2 = 2
    case level3 = 3
    case level4 = 4
    case level5 = 5
}

// MARK: - Main App Manager
class AppManager: ObservableObject {
    @Published var progressArray: [Bool] = [false, false, false, false, false]
    @Published var viewedChallenge: Int? = nil
    @Published var levelCompletedAnimation: Bool = false
    @Published var videoReveal: Bool = false
    @Published var rowsMoved: Bool = false
    
    let challenges: [Challenge] = [
        Challenge(id: 1, icon: "magnifyingglass"),
        Challenge(id: 2, icon: "touchid"),
        Challenge(id: 3, icon: "terminal"),
        Challenge(id: 4, icon: "memorychip"),
        Challenge(id: 5, icon: "shippingbox")
    ]
    
    init() {
        loadProgress()
    }
    
    func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: "progressArray"),
           let decoded = try? JSONDecoder().decode([Bool].self, from: data) {
            progressArray = decoded
        }
    }
    
    func saveProgress() {
        if let encoded = try? JSONEncoder().encode(progressArray) {
            UserDefaults.standard.set(encoded, forKey: "progressArray")
        }
    }
    
    func updateProgress(levelCompleted: Int, completeAll: Bool = false) {
        if completeAll {
            progressArray = [true, true, true, true, true]
        } else {
            progressArray[levelCompleted - 1] = true
        }
        
        saveProgress()
        
        if !completeAll {
            // Trigger completion animation
            levelCompletedAnimation = true
            
            // Check if all levels are completed
            let allCompleted = progressArray.allSatisfy { $0 }
            if allCompleted && !rowsMoved {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.rowsMoved = true
                    
                    // After rows animation, reveal video
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.videoReveal = true
                    }
                }
            }
            
            // Return to home screen after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.levelCompletedAnimation = false
                self.viewedChallenge = nil
            }
        }
    }
    
    var progressPercentage: Double {
        let completed = progressArray.filter { $0 }.count
        return Double(completed) / Double(progressArray.count)
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var appManager = AppManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(red: 0.13, green: 0.13, blue: 0.13)
                    .ignoresSafeArea()
                
                VStack {
                    // Header
                    HeaderView(appManager: appManager)
                    
                    Spacer()
                    
                    // Main Content
                    if appManager.levelCompletedAnimation {
                        CompletionAnimationView()
                    } else if let challenge = appManager.viewedChallenge {
                        ChallengeView(challengeId: challenge, appManager: appManager)
                    } else {
                        HomeScreenView(appManager: appManager, screenSize: geometry.size)
                    }
                    
                    Spacer()
                    
                    // Progress Bar
                    ProgressBarView(appManager: appManager)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Header View
struct HeaderView: View {
    @ObservedObject var appManager: AppManager
    
    var body: some View {
        ZStack {
            HStack {
                if appManager.viewedChallenge != nil {
                    Button(action: {
                        appManager.viewedChallenge = nil
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.81, green: 0.81, blue: 0.81))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Text("Hostinger Hunt")
                .font(.custom("Fira Code", size: 28))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.81, green: 0.81, blue: 0.81))
        }
        .padding(.top, 20)
    }
}

// MARK: - Home Screen View
struct HomeScreenView: View {
    @ObservedObject var appManager: AppManager
    let screenSize: CGSize
    
    var body: some View {
        ZStack {
            VStack(spacing: 60) {
                // Top Row
                HStack(spacing: 30) {
                    ForEach(0..<3) { index in
                        ChallengeItemView(
                            challenge: appManager.challenges[index],
                            isCompleted: appManager.progressArray[index],
                            action: { appManager.viewedChallenge = index + 1 }
                        )
                    }
                }
                .offset(y: appManager.rowsMoved ? -160 : 0)
                .animation(.easeInOut(duration: 3), value: appManager.rowsMoved)
                
                // Bottom Row
                HStack(spacing: 30) {
                    ChallengeItemView(
                        challenge: appManager.challenges[3],
                        isCompleted: appManager.progressArray[3],
                        action: { appManager.viewedChallenge = 4 }
                    )
                    ChallengeItemView(
                        challenge: appManager.challenges[4],
                        isCompleted: appManager.progressArray[4],
                        action: { appManager.viewedChallenge = 5 }
                    )
                }
                .offset(y: appManager.rowsMoved ? 160 : 0)
                .animation(.easeInOut(duration: 3), value: appManager.rowsMoved)
            }
            
            // Video Reveal
            if appManager.videoReveal {
                VideoPlayerView()
                    .opacity(appManager.videoReveal ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: appManager.videoReveal)
            }
        }
        .padding()
    }
}

// MARK: - Challenge Item View
struct ChallengeItemView: View {
    let challenge: Challenge
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        isCompleted ? Color(red: 1.0, green: 0.75, blue: 0.1) : Color(red: 0.81, green: 0.81, blue: 0.81),
                        lineWidth: 3
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: challenge.icon)
                    .font(.system(size: 48))
                    .foregroundColor(
                        isCompleted ? Color(red: 1.0, green: 0.75, blue: 0.1) : Color(red: 0.81, green: 0.81, blue: 0.81)
                    )
            }
        }
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.3), value: isCompleted)
        .onTapGesture {
            // Add hover effect simulation
            withAnimation(.easeInOut(duration: 0.1)) {
                // Scale effect handled by SwiftUI button style
            }
        }
    }
}

// MARK: - Progress Bar View
struct ProgressBarView: View {
    @ObservedObject var appManager: AppManager
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(height: 20)
            
            // Progress Fill
            HStack {
                Rectangle()
                    .fill(Color(red: 1.0, green: 0.75, blue: 0.1))
                    .frame(height: 20)
                    .overlay(
                        Rectangle()
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .scaleEffect(x: appManager.progressPercentage, y: 1, anchor: .leading)
                    .animation(.easeInOut(duration: 0.5), value: appManager.progressPercentage)
                
                Spacer()
            }
            
            // Vertical Lines
            HStack {
                ForEach(1..<5) { index in
                    Rectangle()
                        .fill(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .frame(width: 2)
                    
                    if index < 4 {
                        Spacer()
                    }
                }
            }
        }
        .frame(width: 300, height: 30)
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}

// MARK: - Completion Animation View
struct CompletionAnimationView: View {
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            Text("🎉 Level Completed! 🎉")
                .font(.custom("Fira Code", size: 32))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.1))
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                opacity = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1)) {
                    opacity = 0
                }
            }
        }
    }
}

// MARK: - Video Player View
struct VideoPlayerView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(width: 560, height: 315)
            
            VStack {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("Congratulations! You're a Winner!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .shadow(radius: 10)
    }
}

// MARK: - Challenge View
struct ChallengeView: View {
    let challengeId: Int
    @ObservedObject var appManager: AppManager
    
    var body: some View {
        VStack {
            switch challengeId {
            case 1:
                Level1View(appManager: appManager)
            case 2:
                Level2View(appManager: appManager)
            case 3:
                Level3View(appManager: appManager)
            case 4:
                Level4View(appManager: appManager)
            case 5:
                Level5View(appManager: appManager)
            default:
                EmptyView()
            }
        }
    }
}

// MARK: - Level 1 View (Search/Detective Challenge)
struct Level1View: View {
    @ObservedObject var appManager: AppManager
    @State private var selectedWord = ""
    @State private var selectedPositions: [(Int, Int)] = []
    @State private var foundWords: [String] = []
    @State private var letterColors: [[Color]] = Array(repeating: Array(repeating: Color.gray.opacity(0.3), count: 12), count: 12)
    
    let wordsToFind = ["CODE", "HOST", "DATABASE", "DEVNOTES", "SERVER", "DOMAIN", "HTML", "NETWORK", "WEB", "JAVASCRIPT"]
    
    let grid = [
        ["A", "C", "O", "D", "E", "F", "G", "S", "C", "R", "I", "N"],
        ["H", "H", "L", "S", "P", "X", "J", "K", "T", "W", "E", "B"],
        ["J", "R", "W", "D", "B", "T", "Y", "U", "I", "T", "A", "T"],
        ["A", "A", "C", "O", "E", "V", "S", "N", "W", "R", "V", "B"],
        ["D", "D", "V", "M", "A", "I", "E", "O", "T", "H", "O", "S"],
        ["N", "A", "H", "A", "S", "T", "R", "E", "R", "E", "G", "A"],
        ["J", "T", "J", "I", "S", "K", "V", "L", "M", "T", "H", "H"],
        ["A", "A", "D", "N", "G", "C", "E", "E", "R", "T", "Y", "O"],
        ["Q", "B", "E", "R", "T", "Y", "R", "I", "O", "P", "L", "S"],
        ["Z", "A", "C", "V", "B", "N", "M", "I", "W", "E", "R", "T"],
        ["Y", "S", "I", "O", "P", "A", "S", "D", "P", "G", "H", "J"],
        ["H", "E", "K", "L", "D", "E", "V", "N", "O", "T", "E", "S"]
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("Code Terminology Word Search")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                // Word Grid - Centered
                VStack(spacing: 2) {
                    ForEach(0..<grid.count, id: \.self) { rowIndex in
                        HStack(spacing: 2) {
                            ForEach(0..<grid[rowIndex].count, id: \.self) { colIndex in
                                Button(action: {
                                    handleLetterClick(letter: grid[rowIndex][colIndex], row: rowIndex, col: colIndex)
                                }) {
                                    Text(grid[rowIndex][colIndex])
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color.black)
                                        .frame(width: 30, height: 30)
                                        .background(letterColors[rowIndex][colIndex])
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                // Selected Word Display - Centered
                VStack(spacing: 10) {
                    Text("Selected Word: \(selectedWord)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Button("Submit Word") {
                        checkWord()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                
                // Words to Find - Centered
                VStack(alignment: .center, spacing: 10) {
                    Text("Words to find:")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach(wordsToFind, id: \.self) { word in
                            Text(word)
                                .font(.system(size: 14))
                                .strikethrough(foundWords.contains(word))
                                .foregroundColor(foundWords.contains(word) ? .gray : .white)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
           
        }
        
    }
    
    private func isAdjacent(lastPosition: (Int, Int)?, newPosition: (Int, Int)) -> Bool {
        guard let lastPosition = lastPosition else { return true }
        
        let (lastRow, lastCol) = lastPosition
        let (newRow, newCol) = newPosition
        
        return abs(newRow - lastRow) <= 1 && abs(newCol - lastCol) <= 1
    }
    
    private func handleLetterClick(letter: String, row: Int, col: Int) {
        let lastPosition = selectedPositions.last
        
        if isAdjacent(lastPosition: lastPosition, newPosition: (row, col)) {
            selectedWord += letter
            selectedPositions.append((row, col))
            
            // Update letter color to green
            letterColors[row][col] = .green
        }
    }
    
    private func checkWord() {
        var newColors = letterColors
        
        if wordsToFind.contains(selectedWord) && !foundWords.contains(selectedWord) {
            foundWords.append(selectedWord)
            
            // Make the letters gold on success
            for (row, col) in selectedPositions {
                newColors[row][col] = .yellow
            }
        } else {
            // Revert back to the default color on failure
            for (row, col) in selectedPositions {
                newColors[row][col] = Color.gray.opacity(0.3)
            }
        }
        
        letterColors = newColors
        selectedWord = ""
        selectedPositions = []
        
        // Check if all words are found
        if foundWords.count == wordsToFind.count {
            appManager.updateProgress(levelCompleted: 1)
        }
    }
}
// MARK: - Level 2 View (Fingerprint/Pattern Challenge)
struct Level2View: View {
    @ObservedObject var appManager: AppManager
    @State private var userInput: String = ""
    @State private var isSuccess: Bool = false
    @State private var errorMessage: String = ""
    @State private var attempts = 0
    
    private let originalMessage = "Talk is cheap. Show me the code."
    
    // Caesar cipher with shift of 3
    private var cipheredMessage: String {
        return originalMessage.map { char in
            if char == " " {
                return " "
            } else if char == "." {
                return "."
            } else {
                let asciiValue = char.asciiValue ?? 0
                return String(Character(UnicodeScalar(asciiValue + 3)))
            }
        }.joined()
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock.shield")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.1))
            
            Text("Decryption Challenge")
                .font(.custom("Fira Code", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Unlock the secret! Decode the encrypted message below to progress.")
                .font(.custom("Fira Code", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            // Display the ciphered message with matrix-style appearance
            Text(cipheredMessage)
                .font(.custom("Fira Code", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 1)
                )
            
            // Text input area
            VStack(alignment: .leading, spacing: 10) {
                Text("Decipher the message here:")
                    .font(.custom("Fira Code", size: 14))
                    .foregroundColor(.gray)
                
                TextEditor(text: $userInput)
                    .font(.custom("Fira Code", size: 16))
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            // Submit button (only show if not successful and no error)
            if !isSuccess && errorMessage.isEmpty {
                Button("Decrypt and Submit") {
                    checkDecryption()
                }
                .buttonStyle(HuntButtonStyle())
            }
            
            // Success message
            if isSuccess {
                Text("Correct! You've deciphered the message.")
                    .font(.custom("Fira Code", size: 16))
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
            
            // Error message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.custom("Fira Code", size: 16))
                    .foregroundColor(.red)
                    .fontWeight(.bold)
            }
            
            // Attempts counter
            if attempts > 0 {
                Text("Attempts: \(attempts)")
                    .font(.custom("Fira Code", size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
    
    private func checkDecryption() {
        attempts += 1
        
        if userInput.trimmingCharacters(in: .whitespacesAndNewlines) == originalMessage {
            isSuccess = true
            // Progress to next level after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                appManager.updateProgress(levelCompleted: 2)
            }
        } else {
            errorMessage = "Wrong Answer. Try Again!"
            // Clear error message after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                errorMessage = ""
            }
        }
    }
}

// MARK: - Level 3 View (Terminal Challenge)
struct Level3View: View {
    @ObservedObject var appManager: AppManager
    @State private var currentQuestion = 0
    @State private var selectedAnswer: Int? = nil
    @State private var isCorrect: Bool? = nil
    @State private var showFeedback = false
    
    private let questions = [
        Question(
            question: "Who is known as the father of the World Wide Web?",
            options: ["Steve Jobs", "Bill Gates", "Tim Berners-Lee", "Mark Zuckerberg"],
            correctAnswer: 2
        ),
        Question(
            question: "Which of these is NOT a way to store data in JavaScript?",
            options: ["Array", "List", "Object", "Set"],
            correctAnswer: 1
        ),
        Question(
            question: "Which one is NOT a feature of Hostinger's Premium Shared Hosting?",
            options: ["Free Domain", "Weekly Backups", "100 Websites", "Free Breakfast"],
            correctAnswer: 3
        )
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.1))
            
            Text("Code Trivia")
                .font(.custom("Fira Code", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                Text(questions[currentQuestion].question)
                    .font(.custom("Fira Code", size: 18))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack(spacing: 12) {
                    ForEach(0..<questions[currentQuestion].options.count, id: \.self) { index in
                        Button(action: {
                            selectedAnswer = index
                        }) {
                            HStack {
                                Image(systemName: selectedAnswer == index ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(selectedAnswer == index ? .blue : .gray)
                                    .font(.system(size: 20))
                                
                                Text(questions[currentQuestion].options[index])
                                    .font(.custom("Fira Code", size: 16))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedAnswer == index ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedAnswer == index ? Color.blue : Color.gray, lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            if !showFeedback {
                Button("Submit Answer") {
                    handleAnswer()
                }
                .buttonStyle(HuntButtonStyle())
                .disabled(selectedAnswer == nil)
            }
            
            if showFeedback {
                Text(isCorrect == true ? "Correct!" : "Wrong Answer, Try Again!")
                    .font(.custom("Fira Code", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(isCorrect == true ? .white : .red)
            }
            
            // Progress indicator
            HStack {
                ForEach(0..<questions.count, id: \.self) { index in
                    Circle()
                        .fill(index <= currentQuestion ? Color.blue : Color.gray)
                        .frame(width: 12, height: 12)
                }
            }
            .padding(.top)
        }
        .padding()
    }
    
    private func handleAnswer() {
        guard let selectedAnswer = selectedAnswer else { return }
        
        let correct = selectedAnswer == questions[currentQuestion].correctAnswer
        isCorrect = correct
        showFeedback = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if correct {
                if currentQuestion + 1 < questions.count {
                    // Move to next question
                    currentQuestion += 1
                    self.selectedAnswer = nil
                    showFeedback = false
                    isCorrect = nil
                } else {
                    // User has completed all questions
                    appManager.updateProgress(levelCompleted: 3)
                }
            } else {
                // Reset for retry
                showFeedback = false
                isCorrect = nil
            }
        }
    }
}

struct Question {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

// MARK: - Level 4 View (Memory Challenge)
struct Level4View: View {
    @ObservedObject var appManager: AppManager
    @State private var cards: [String] = []
    @State private var flippedIndexes: [Int] = []
    @State private var matchedPairs = 0
    @State private var matchedIndexes: [Int] = []
    
    private let symbols = ["🌍", "🖥️", "☁️", "🔒", "📦", "⚙️", "🔌", "🔧"]
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.1))
            
            Text("Memory Card Game")
                .font(.custom("Fira Code", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Your goal is to match pairs of cards with identical symbols. Simply tap to flip a card, then tap another to find its match. Matched pairs remain face-up, while non-matches flip back down. Win by matching all card pairs!")
                .font(.custom("Fira Code", size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(0..<cards.count, id: \.self) { index in
                    CardView(
                        symbol: cards[index],
                        isFlipped: flippedIndexes.contains(index) || matchedIndexes.contains(index),
                        isMatched: matchedIndexes.contains(index)
                    ) {
                        handleCardClick(index: index)
                    }
                }
            }
            .padding()
            
            Text("Matched Pairs: \(matchedPairs)/8")
                .font(.custom("Fira Code", size: 16))
                .foregroundColor(.white)
        }
        .padding()
        .onAppear {
            setupGame()
        }
    }
    
    private func setupGame() {
        // Create deck with pairs of symbols and shuffle
        let deck = (symbols + symbols).shuffled()
        cards = deck
    }
    
    private func handleCardClick(index: Int) {
        // Don't allow clicking on already matched cards or cards that are being processed
        if matchedIndexes.contains(index) || flippedIndexes.count == 2 {
            return
        }
        
        if flippedIndexes.isEmpty {
            // First card flipped
            flippedIndexes = [index]
        } else if flippedIndexes.count == 1 {
            let firstIndex = flippedIndexes[0]
            
            // Don't allow clicking the same card twice
            if firstIndex == index {
                return
            }
            
            // Second card flipped
            flippedIndexes.append(index)
            
            // Check for match
            if cards[firstIndex] == cards[index] {
                // Match found
                matchedPairs += 1
                matchedIndexes.append(contentsOf: [firstIndex, index])
                flippedIndexes = []
                
                // Check if game is complete
                if matchedPairs == 8 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        appManager.updateProgress(levelCompleted: 4)
                    }
                }
            } else {
                // No match - flip cards back after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    flippedIndexes = []
                }
            }
        }
    }
}

struct CardView: View {
    let symbol: String
    let isFlipped: Bool
    let isMatched: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isMatched ? Color.green.opacity(0.3) : Color.blue.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isMatched ? Color.green : Color.blue, lineWidth: 2)
                    )
                    .frame(width: 60, height: 60)
                
                if isFlipped {
                    Text(symbol)
                        .font(.system(size: 30))
                } else {
                    Text("?")
                        .font(.custom("Fira Code", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isFlipped ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFlipped)
    }
}
// MARK: - Level 5 View (Box/Package Challenge)
struct Level5View: View {
    @ObservedObject var appManager: AppManager
    @State private var boxes = [false, false, false, false, false]
    @State private var showFeedback = false
    @State private var isCorrect = false
    
    private let emojis = ["💻", "🐞", "📖", "⚙️", "🚀"]
    private let chosenBox = 1 // The index of the "bug" emoji which is the correct answer
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "questionmark.diamond")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.1))
            
            Text("Riddle Reveal")
                .font(.custom("Fira Code", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Answer the riddle related to coding and select the right digital box.")
                .font(.custom("Fira Code", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                Text("The more you code, the more of me there is.")
                    .font(.custom("Fira Code", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("I may be gone for now but you can't get rid of me forever.")
                    .font(.custom("Fira Code", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("What am I?")
                    .font(.custom("Fira Code", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
                    )
            )
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                ForEach(0..<boxes.count, id: \.self) { index in
                    Button(action: {
                        handleClickBox(index: index)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(boxes[index] ? Color.green.opacity(0.3) : Color.blue.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(boxes[index] ? Color.green : Color.blue, lineWidth: 2)
                                )
                                .frame(width: 80, height: 80)
                            
                            Text(getBoxContent(index: index))
                                .font(.system(size: 40))
                                .scaleEffect(boxes[index] ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: boxes[index])
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(boxes[index] && index != chosenBox)
                }
            }
            .padding(.horizontal)
            
            if showFeedback {
                Text(isCorrect ? "A bug. That's Correct!" : "Wrong Answer, Try Again!")
                    .font(.custom("Fira Code", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(isCorrect ? .white : .red)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    )
            }
        }
        .padding()
    }
    
    private func getBoxContent(index: Int) -> String {
        if boxes[index] && index == chosenBox {
            return "🏆"  // Trophy if correct box is clicked
        } else {
            return emojis[index]
        }
    }
    
    private func handleClickBox(index: Int) {
        if index == chosenBox {
            // Correct answer
            isCorrect = true
            showFeedback = true
            
            boxes[index] = true
            
            // Delay completion to let user see they found the treasure
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                handleCompletion()
            }
        } else {
            // Wrong answer
            isCorrect = false
            showFeedback = true
            
            boxes[index] = true
            
            // Reset the clicked box and hide feedback after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                boxes[index] = false
                showFeedback = false
            }
        }
    }
    
    private func handleCompletion() {
        appManager.updateProgress(levelCompleted: 5)
    }
}

// MARK: - Custom Button Style
struct HuntButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color(red: 1.0, green: 0.75, blue: 0.1))
            .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
            .font(.custom("Fira Code", size: 16))
            .fontWeight(.medium)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
