import SwiftUI

struct WordScramble: View {
    @State private var usedWords = [String]()
    @State private var rootWord = "swift"
    @State private var newWord = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .onSubmit {
                            addNew()
                        }
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        Text(word)
                    }
                }
            }
            .navigationTitle(rootWord)
        }
    }
    
    func addNew() {
        let ans = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard ans.count > 0 else { return }
        
        usedWords.insert(ans, at: 0)
        newWord = ""
    }
}

#Preview {
    WordScramble()
}
