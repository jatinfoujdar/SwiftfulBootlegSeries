import SwiftUI

struct ContentView: View {
    @StateObject private var storyGenerator = BedtimeStoryGenerator()
    
    var body: some View {
        NavigationView {
            storyGenerator.currentView
                .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

class BedtimeStoryGenerator: ObservableObject {
    @Published var currentStep = 0
    @Published var isGenerating = false
    @Published var generatedStory = ""
    @Published var formData = FormData()
    
    struct FormData {
        var age = ""
        var gender = ""
        var interests: [String] = []
        var style = ""
        var lesson = ""
    }
    
    let interests = [
        "Animals", "Space & Stars", "Ocean & Sea Life", "Dinosaurs", "Magic & Fantasy",
        "Sports", "Music", "Art & Drawing", "Nature & Forest", "Superheroes",
        "Vehicles & Transportation", "Cooking & Food", "Science & Experiments"
    ]
    
    let styles = [
        StoryStyle(value: "funny", label: "Funny & Silly", emoji: "😄", description: "Giggles and laughs throughout"),
        StoryStyle(value: "adventurous", label: "Adventurous & Exciting", emoji: "🌟", description: "Thrilling quests and discoveries"),
        StoryStyle(value: "gentle", label: "Gentle & Calming", emoji: "🌙", description: "Peaceful and soothing"),
        StoryStyle(value: "magical", label: "Magical & Enchanting", emoji: "✨", description: "Fantasy and wonder"),
        StoryStyle(value: "educational", label: "Educational & Learning", emoji: "📚", description: "Fun facts and knowledge")
    ]
    
    struct StoryStyle {
        let value: String
        let label: String
        let emoji: String
        let description: String
    }
    
    @ViewBuilder
    var currentView: some View {
        switch currentStep {
        case 0:
            AgeStepView(generator: self)
        case 1:
            GenderStepView(generator: self)
        case 2:
            InterestsStepView(generator: self)
        case 3:
            StyleStepView(generator: self)
        case 4:
            LessonStepView(generator: self)
        case 5:
            LoadingStepView(generator: self)
        case 6:
            StoryDisplayView(generator: self)
        default:
            AgeStepView(generator: self)
        }
    }
    
    func nextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep += 1
        }
    }
    
    func prevStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep -= 1
        }
    }
    
    func resetForm() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = 0
            generatedStory = ""
            formData = FormData()
        }
    }
    
    func generateStory() {
        isGenerating = true
        currentStep = 5
        
        // Simulate API call to Claude
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.simulateStoryGeneration()
        }
    }
    
    private func simulateStoryGeneration() {
        // This would normally be a real API call to Claude
        let sampleStory = """
        Once upon a time, in a magical garden where flowers sang lullabies and butterflies painted the sky with rainbow colors, there lived a curious little \(formData.gender) named Alex who was \(formData.age) years old.

        Alex loved \(formData.interests.joined(separator: ", ")) and spent every day exploring the wonders of the garden. One evening, as the sun painted the sky in gentle purples and pinks, Alex discovered something extraordinary...

        The story continues with adventure, friendship, and the important lesson about \(formData.lesson). Through this magical journey, Alex learned that with courage and kindness, any challenge can be overcome.

        As the stars began to twinkle overhead, Alex felt grateful for all the wonderful experiences of the day. With a heart full of joy and wisdom, Alex drifted off to sleep, dreaming of tomorrow's adventures.

        The End.
        """
        
        generatedStory = sampleStory
        isGenerating = false
        currentStep = 6
    }
}

struct AgeStepView: View {
    @ObservedObject var generator: BedtimeStoryGenerator
    
    var body: some View {
        StepContainerView(
            step: 1,
            totalSteps: 5,
            title: "How old is your little one?",
            subtitle: "This helps us choose the perfect vocabulary and themes",
            iconName: "sparkles",
            iconColor: .indigo,
            canProceed: !generator.formData.age.isEmpty,
            onNext: { generator.nextStep() }
        ) {
            VStack(spacing: 24) {
                TextField("Enter age (2-12)", text: $generator.formData.age)
                    .textFieldStyle(CustomTextFieldStyle())
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct GenderStepView: View {
    @ObservedObject var generator: BedtimeStoryGenerator
    
    var body: some View {
        StepContainerView(
            step: 2,
            totalSteps: 5,
            title: "Tell us about your child",
            subtitle: "We'll use the right pronouns and perspective",
            iconName: "heart.fill",
            iconColor: .purple,
            canProceed: !generator.formData.gender.isEmpty,
            onNext: { generator.nextStep() },
            onBack: { generator.prevStep() }
        ) {
            VStack(spacing: 16) {
                ForEach(["boy", "girl", "other"], id: \.self) { gender in
                    SelectionButton(
                        title: gender.capitalized,
                        isSelected: generator.formData.gender == gender,
                        action: { generator.formData.gender = gender }
                    )
                }
            }
        }
    }
}

struct InterestsStepView: View {
    @ObservedObject var generator: BedtimeStoryGenerator
    
    var body: some View {
        StepContainerView(
            step: 3,
            totalSteps: 5,
            title: "What does your child love?",
            subtitle: "Pick 1-3 things that spark their imagination",
            iconName: "star.fill",
            iconColor: .pink,
            canProceed: !generator.formData.interests.isEmpty,
            onNext: { generator.nextStep() },
            onBack: { generator.prevStep() }
        ) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(generator.interests, id: \.self) { interest in
                    InterestButton(
                        title: interest,
                        isSelected: generator.formData.interests.contains(interest),
                        action: { toggleInterest(interest) }
                    )
                }
            }
        }
    }
    
    private func toggleInterest(_ interest: String) {
        if generator.formData.interests.contains(interest) {
            generator.formData.interests.removeAll { $0 == interest }
        } else {
            generator.formData.interests.append(interest)
        }
    }
}

struct StyleStepView: View {
    @ObservedObject var generator: BedtimeStoryGenerator
    
    var body: some View {
        StepContainerView(
            step: 4,
            totalSteps: 5,
            title: "What kind of story would you like?",
            subtitle: "Choose the tone that fits bedtime best",
            iconName: "book.fill",
            iconColor: .orange,
            canProceed: !generator.formData.style.isEmpty,
            onNext: { generator.nextStep() },
            onBack: { generator.prevStep() }
        ) {
            VStack(spacing: 12) {
                ForEach(generator.styles, id: \.value) { style in
                    StyleButton(
                        style: style,
                        isSelected: generator.formData.style == style.value,
                        action: { generator.formData.style = style.value }
                    )
                }
            }
        }
    }
}

struct LessonStepView: View {
    @ObservedObject var generator: BedtimeStoryGenerator
    
    var body: some View {
        StepContainerView(
            step: 5,
            totalSteps: 5,
            title: "What lesson should we include?",
            subtitle: "What important message should they learn?",
            iconName: "heart.fill",
            iconColor: .green,
            canProceed: !generator.formData.lesson.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            onNext: { generator.generateStory() },
            onBack: { generator.prevStep() },
            nextButtonTitle: "Create Story",
            nextButtonIcon: "sparkles"
        ) {
            VStack(spacing: 24) {
                TextEditor(text: $generator.formData.lesson)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.green.opacity(0.3), lineWidth: 2)
                    )
                    .font(.system(size: 18, design: .rounded))
                    .frame(height: 120)
                
                if generator.formData.lesson.isEmpty {
                    Text("Examples: Being kind to others, trying new things, sharing is caring, being brave when scared...")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct LoadingStepView: View {
    @ObservedObject var generator: BedtimeStoryGenerator
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.indigo.opacity(0.1), Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                VStack(spacing: 24) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.indigo)
                        .opacity(0.7)
                        .scaleEffect(generator.isGenerating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(), value: generator.isGenerating)
                    
                    Text("Creating your magical story...")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Our storytelling magic is working...")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.indigo)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 32)
        }
    }
}

struct StoryDisplayView: View {
    @ObservedObject var generator: BedtimeStoryGenerator
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.indigo.opacity(0.1), Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    ZStack {
                        LinearGradient(
                            colors: [Color.indigo, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 24))
                                Text("Your bedtime story is ready!")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            
                            Text("Sweet dreams are just a story away!")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                    }
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    
                    // Story Content
                    VStack(spacing: 24) {
                        ScrollView {
                            VStack(spacing: 16) {
                                Text(generator.generatedStory)
                                    .font(.system(size: 18, weight: .medium, design: .serif))
                                    .foregroundColor(.primary)
                                    .lineSpacing(6)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [Color.yellow.opacity(0.1), Color.orange.opacity(0.1)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 3)
                                    )
                            }
                        }
                        .frame(maxHeight: 400)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.indigo)
                            Text("Sweet dreams!")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.indigo)
                            Image(systemName: "star.fill")
                                .foregroundColor(.indigo)
                        }
                        
                        Button(action: { generator.resetForm() }) {
                            HStack {
                                Image(systemName: "sparkles")
                                Text("Create Another Story")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                Image(systemName: "heart.fill")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [Color.indigo, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                        }
                        .scaleEffect(0.98)
                        .animation(.easeInOut(duration: 0.1), value: generator.generatedStory)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
        }
    }
}

struct StepContainerView<Content: View>: View {
    let step: Int
    let totalSteps: Int
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    let canProceed: Bool
    let onNext: () -> Void
    let onBack: (() -> Void)?
    let nextButtonTitle: String
    let nextButtonIcon: String
    let content: Content
    
    init(
        step: Int,
        totalSteps: Int,
        title: String,
        subtitle: String,
        iconName: String,
        iconColor: Color,
        canProceed: Bool,
        onNext: @escaping () -> Void,
        onBack: (() -> Void)? = nil,
        nextButtonTitle: String = "Continue",
        nextButtonIcon: String = "arrow.right",
        @ViewBuilder content: () -> Content
    ) {
        self.step = step
        self.totalSteps = totalSteps
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.iconColor = iconColor
        self.canProceed = canProceed
        self.onNext = onNext
        self.onBack = onBack
        self.nextButtonTitle = nextButtonTitle
        self.nextButtonIcon = nextButtonIcon
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.indigo.opacity(0.1), Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                VStack(spacing: 24) {
                    Image(systemName: iconName)
                        .font(.system(size: 48))
                        .foregroundColor(iconColor)
                    
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text(subtitle)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                content
                
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        if let onBack = onBack {
                            Button(action: onBack) {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Back")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                }
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(20)
                            }
                        }
                        
                        Button(action: onNext) {
                            HStack {
                                Text(nextButtonTitle)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                Image(systemName: nextButtonIcon)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                canProceed
                                    ? LinearGradient(colors: [iconColor, iconColor.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(20)
                        }
                        .disabled(!canProceed)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Step \(step) of \(totalSteps)")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        ProgressView(value: Double(step), total: Double(totalSteps))
                            .tint(iconColor)
                            .scaleEffect(y: 2)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 24)
        }
    }
}

struct SelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    isSelected
                        ? LinearGradient(colors: [Color.purple, Color.purple.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.purple : Color.gray.opacity(0.3), lineWidth: 2)
                )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct InterestButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    isSelected
                        ? LinearGradient(colors: [Color.pink, Color.pink.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.pink : Color.gray.opacity(0.3), lineWidth: 2)
                )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct StyleButton: View {
    let style: BedtimeStoryGenerator.StoryStyle
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(style.emoji)
                    .font(.system(size: 30))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(style.label)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(style.description)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                isSelected
                    ? LinearGradient(colors: [Color.orange, Color.orange.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                    : LinearGradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.orange : Color.gray.opacity(0.3), lineWidth: 2)
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.indigo.opacity(0.3), lineWidth: 2)
            )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
