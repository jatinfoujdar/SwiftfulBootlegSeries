import SwiftUI

struct FiltersView: View {
    @State private var selectedLocation = "Delhi"
    @State private var selectedDate = Date()
    @State private var age = 12
    @State private var currentAvatarIndex = 0
    let avatarImages = ["avatar1", "avatar2", "avatar3"] // Replace with your image names
    @State private var selectedTime = Date()
    @State private var selectedGenre = "All genres"
    @State private var selectedPrice = "All price"
    @State private var timer: Timer? = nil

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }

    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Spacer()
                    Text("Filters")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        print("Close filters tapped")
                        stopAvatarAnimation()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(.trailing)
                    }
                }
                .padding(.vertical)

                // Filter Options
                VStack(spacing: 16) {
                    FilterRow(icon: "location.fill", label: "Location", value: selectedLocation)
                        .onTapGesture {
                            print("Location tapped")
                        }

                    FilterRow(icon: "calendar", label: "Dates", value: dateFormatter.string(from: selectedDate))
                        .onTapGesture {
                            print("Dates tapped")
                        }

                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Text("Friends attend")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            ZStack {
                                ForEach(0..<avatarImages.count, id: \.self) { index in
                                    let isCurrent = currentAvatarIndex % avatarImages.count == index
                                    let previousIndex = (currentAvatarIndex - 1 + avatarImages.count) % avatarImages.count
                                    let isPrevious = previousIndex == index

                                    Image(avatarImages[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 24)
                                        .clipShape(Circle())
                                        .offset(y: isCurrent ? 0 : (isPrevious ? -30 : 30))
                                        .opacity(isCurrent || isPrevious ? 1 : 0)
                                        .scaleEffect(isCurrent ? 1 : 0.8)
                                        .animation(
                                            isCurrent || isPrevious ? .easeInOut(duration: 0.5) : .default,
                                            value: currentAvatarIndex
                                        )
                                }
                                Circle()
                                    .stroke(Color.black, lineWidth: 1)
                                    .frame(width: 24, height: 24)
                            }
                            .frame(width: 24, height: 24)

                            Text("\(age)+")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(.white)

                            Button(action: {
                                age += 1
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 8)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .onTapGesture {
                        print("Friends attend tapped")
                    }

                    FilterRow(icon: "clock.fill", label: "Time", value: timeFormatter.string(from: selectedTime))
                        .onTapGesture {
                            print("Time tapped")
                        }

                    FilterRow(icon: "music.note.list", label: "Genres", value: selectedGenre)
                        .onTapGesture {
                            print("Genres tapped")
                        }

                    FilterRow(icon: "tag.fill", label: "Price", value: selectedPrice)
                        .onTapGesture {
                            print("Price tapped")
                        }
                }
                .padding()

                Spacer()

                // Bottom Buttons
                HStack {
                    Button(action: {
                        print("Reset all tapped")
                        selectedLocation = "Delhi"
                        selectedDate = Date()
                        age = 12
                        currentAvatarIndex = 0
                        selectedTime = Date()
                        selectedGenre = "All genres"
                        selectedPrice = "All price"
                        startAvatarWheelAnimation()
                    }) {
                        Text("Reset all")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {
                        print("Continue with 4 tapped")
                        stopAvatarAnimation()
                    }) {
                        Text("Continue with 4")
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .navigationBarHidden(true)
            .onAppear(perform: startAvatarWheelAnimation)
            .onDisappear(perform: stopAvatarAnimation)
        }
    }

    func startAvatarWheelAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation {
                currentAvatarIndex += 1
            }
        }
    }

    func stopAvatarAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

struct FilterRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            Text(label)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView()
            .preferredColorScheme(.dark)
    }
}
