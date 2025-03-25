import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                HStack {
                    Image("vk")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.circle)
                        .frame(height: 100)
                        .background {
                            Circle()
                                .foregroundStyle(.blue)
                                .offset(x: 10, y: 10)
                        }
                        .background {
                            Circle()
                                .foregroundStyle(.yellow)
                                .offset(x: -10, y: 10)
                        }
                        .background {
                            Circle()
                                .foregroundStyle(.red)
                                .offset(x: 0, y: -10)
                        }
                        .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Virat")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Programmer")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Skills Section
                Group {
                    Text("Skills")
                        .font(.title)
                        .fontWeight(.bold)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    HStack {
                        Text("App Development")
                            .bold()
                            .font(.title3)
                        Spacer()
                        Text("2 Apps in store")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Swift")
                        Spacer()
                        Text("5+ Years")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("iOS Development")
                        Spacer()
                        Text("3+ Years")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Work Experience Section
                Group {
                    Text("Work Experience")
                        .font(.title)
                        .fontWeight(.bold)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading) {
                        Text("Software Engineer")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("ABC Tech Company | 2023 - Present")
                            .foregroundStyle(.secondary)
                        Text("• Worked on iOS apps using Swift and SwiftUI.")
                        Text("• Collaborated with design and product teams to implement new features.")
                        Text("• Optimized app performance and fixed bugs.")
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Junior Developer")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("XYZ Corp | 2021 - 2023")
                            .foregroundStyle(.secondary)
                        Text("• Developed and maintained web applications using JavaScript, React, and Node.js.")
                        Text("• Improved UI/UX design for better user engagement.")
                        Text("• Worked on backend APIs and optimized database queries.")
                    }
                }
                
                // Education Section
                Group {
                    Text("Education")
                        .font(.title)
                        .fontWeight(.bold)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading) {
                        Text("Bachelor of Science in Computer Science")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("XYZ University | 2017 - 2021")
                            .foregroundStyle(.secondary)
                        Text("• Learned programming languages like C++, Java, Python.")
                        Text("• Worked on multiple projects related to machine learning and AI.")
                    }
                }
                
                // Interests Section
                Group {
                    Text("Interests")
                        .font(.title)
                        .fontWeight(.bold)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading) {
                        Text("• Traveling")
                        Text("• Coding challenges & Hackathons")
                        Text("• Music and Guitar")
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
