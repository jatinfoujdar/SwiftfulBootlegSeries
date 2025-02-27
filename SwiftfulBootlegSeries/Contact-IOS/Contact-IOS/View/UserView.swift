import SwiftUI

struct UserView: View {
    @State private var users: [User] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var searchQuery: String = ""
    @State private var isSearchActive = false
    
    var filteredUsers: [User] {
        
        let filtered = searchQuery.isEmpty ? users : users.filter { user in
            user.firstName.lowercased().contains(searchQuery.lowercased()) ||
            user.lastName.lowercased().contains(searchQuery.lowercased())
        }
        
    
        return filtered.sorted {
            ($0.firstName + $0.lastName).lowercased() < ($1.firstName + $1.lastName).lowercased()
        }
    }
    
    var groupedUsers: [(letter: String, users: [User])] {
        let grouped = Dictionary(grouping: filteredUsers) { user in
            String(user.firstName.prefix(1)).uppercased()
        }
        
        return grouped.keys.sorted().map { letter in
            (letter, grouped[letter]!)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                   
                    if isSearchActive {
                        TextField("Search...", text: $searchQuery)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .transition(.move(edge: .top))
                            .animation(.easeInOut, value: isSearchActive)
                    }

                    List {
                        ForEach(groupedUsers, id: \.letter) { group in
                            Section(header: Text(group.letter).font(.headline)) {
                                ForEach(group.users) { user in
                                    UserRow(user: user)
                                        .listRowSeparator(.hidden)
                                        .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .onAppear {
                loadUsers()
            }
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                       
                    }) {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isSearchActive.toggle()
                                if !isSearchActive {
                                    searchQuery = ""
                                }
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
            }
        }
    }
    
    private func loadUsers() {
        isLoading = true
        Task {
            do {
                let fetchedUsers = try await UserNetwork.shared.ApiService()
                users = fetchedUsers
                isLoading = false
            } catch {
                errorMessage = "Failed to load users: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: user.image)) { phase in
                if let image = phase.image {
                    image.resizable()
                         .frame(width: 40, height: 40)
                         .clipShape(Circle())
                } else if phase.error != nil {
                    Text("❌")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                        .padding(10)
                        .background(Circle().fill(Color.gray))
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 40, height: 40)
                }
            }
            
            Text("\(user.firstName) \(user.lastName)")
                .font(.headline)
            
            Spacer()
        }
        .padding(.leading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
