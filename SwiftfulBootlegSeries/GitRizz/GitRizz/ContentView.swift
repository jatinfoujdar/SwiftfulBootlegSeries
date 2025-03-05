import SwiftUI

// MARK: - Models
struct GitHubComparison: Identifiable {
    let id = UUID()
    var matchPercentage: Double
    var commonTechnologies: [String]
    var commonProjectTypes: [String]
    var activityCompatibility: Double
    var languageOverlap: [String]
}

struct GitHubUser: Identifiable {
    let id = UUID()
    let username: String
    let avatarUrl: String
    let bio: String
    let location: String
    let repositories: Int
    let followers: Int
    let following: Int
    let techStack: [String]
    let topProjects: [String]
}

// MARK: - Main View
struct GitHubComparisonView: View {
    @StateObject private var viewModel = GitHubComparisonViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerView
                profileInputs
                
                if viewModel.isLoading {
                    loadingView
                } else if let comparison = viewModel.comparison {
                    ComparisonResultView(comparison: comparison)
                }
                
                if let profile1 = viewModel.profile1, let profile2 = viewModel.profile2 {
                    ProfileComparisonView(profile1: profile1, profile2: profile2)
                }
            }
            .padding()
        }
        .navigationTitle("GitHub Match Analysis")
    }
    
    private var headerView: some View {
        Text("Compare GitHub Profiles ⚡️")
            .font(.title2)
            .fontWeight(.bold)
    }
    
    private var profileInputs: some View {
        VStack(spacing: 15) {
            ProfileInputField(
                username: $viewModel.username1,
                placeholder: "First GitHub username"
            )
            
            ProfileInputField(
                username: $viewModel.username2,
                placeholder: "Second GitHub username"
            )
            
            compareButton
        }
    }
    
    private var compareButton: some View {
        Button(action: viewModel.compareProfiles) {
            Text("Compare Profiles")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .disabled(viewModel.username1.isEmpty || viewModel.username2.isEmpty)
    }
    
    private var loadingView: some View {
        ProgressView("Analyzing profiles...")
    }
}

// MARK: - Comparison Result View
struct ComparisonResultView: View {
    let comparison: GitHubComparison
    
    var body: some View {
        VStack(spacing: 20) {
            matchPercentageView
            commonTechView
            commonProjectTypesView
            activityCompatibilityView
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var matchPercentageView: some View {
        VStack {
            Text("Match Score")
                .font(.headline)
            
            Text("\(Int(comparison.matchPercentage * 100))%")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.blue)
        }
    }
    
    private var commonTechView: some View {
        VStack(alignment: .leading) {
            Text("Common Technologies")
                .font(.headline)
            
            FlowLayout(items: comparison.commonTechnologies) { tech in
                Text(tech)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(15)
            }
        }
    }
    
    private var commonProjectTypesView: some View {
        VStack(alignment: .leading) {
            Text("Similar Project Interests")
                .font(.headline)
            
            ForEach(comparison.commonProjectTypes, id: \.self) { type in
                Text("• \(type)")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var activityCompatibilityView: some View {
        VStack {
            Text("Activity Compatibility")
                .font(.headline)
            
            ProgressView(value: comparison.activityCompatibility)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
    }
}

// MARK: - Profile Comparison View
struct ProfileComparisonView: View {
    let profile1: GitHubUser
    let profile2: GitHubUser
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                ProfileCard(profile: profile1)
                ProfileCard(profile: profile2)
            }
            
            languageComparisonView
        }
    }
    
    private var languageComparisonView: some View {
        VStack(alignment: .leading) {
            Text("Language Comparison")
                .font(.headline)
            
            ForEach(Array(zip(profile1.techStack, profile2.techStack)), id: \.0) { lang1, lang2 in
                if lang1 == lang2 {
                    Text("✅ Both use \(lang1)")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct ProfileInputField: View {
    @Binding var username: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $username)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
    }
}

struct ProfileCard: View {
    let profile: GitHubUser
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: profile.avatarUrl)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            Text("@\(profile.username)")
                .font(.subheadline)
                .bold()
            
            Text("\(profile.repositories) repos")
                .font(.caption)
        }
    }
}

// MARK: - Flow Layout
struct FlowLayout: View {
    let items: [String]
    let itemView: (String) -> any View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0..<items.count, id: \.self) { index in
                AnyView(itemView(items[index]))
            }
        }
    }
}

// MARK: - ViewModel
class GitHubComparisonViewModel: ObservableObject {
    @Published var username1 = ""
    @Published var username2 = ""
    @Published var profile1: GitHubUser?
    @Published var profile2: GitHubUser?
    @Published var comparison: GitHubComparison?
    @Published var isLoading = false
    
    func compareProfiles() {
        isLoading = true
        
        // Simulating API call with sample data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Sample data for satish-kumar75
            self.profile1 = GitHubUser(
                username: self.username1,
                avatarUrl: "https://github.com/\(self.username1).png",
                bio: "Frontend Developer ❤️",
                location: "Patna, India",
                repositories: 36,
                followers: 13,
                following: 10,
                techStack: ["React.js", "JavaScript", "TypeScript", "HTML5", "CSS3"],
                topProjects: []
            )
            
            // Sample data for second profile
            self.profile2 = GitHubUser(
                username: self.username2,
                avatarUrl: "https://github.com/\(self.username2).png",
                bio: "Full Stack Developer",
                location: "New York",
                repositories: 42,
                followers: 20,
                following: 15,
                techStack: ["React.js", "Node.js", "JavaScript", "Python", "MongoDB"],
                topProjects: []
            )
            
            // Calculate comparison
            self.comparison = GitHubComparison(
                matchPercentage: 0.75,
                commonTechnologies: ["React.js", "JavaScript"],
                commonProjectTypes: ["Web Development", "Frontend Applications"],
                activityCompatibility: 0.8,
                languageOverlap: ["JavaScript", "TypeScript"]
            )
            
            self.isLoading = false
        }
    }
}

// MARK: - Preview
struct GitHubComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GitHubComparisonView()
        }
    }
}
