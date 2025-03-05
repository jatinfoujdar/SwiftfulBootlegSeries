import SwiftUI
import AVFoundation
import AVKit

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var name: String = ""
    @State private var isCandleLit: Bool = false
    @State private var showingShareSheet: Bool = false
    @State private var showConfetti = false
    @State private var showBirthdayText = false
    
    var body: some View {
        ZStack {
            // Dark Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Main Content
            VStack(spacing: 20) {
                Image("urbanbrush-20210210104354908637")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top)
                    .colorInvert()
                
                // Happy Birthday Text
                if showBirthdayText {
                    VStack(spacing: 10) {
                        Text("Happy Birthday")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(EllipticalGradient(colors:[.blue, .indigo], center: .center, startRadiusFraction: 0.0, endRadiusFraction: 0.5))
                            .transition(.scale.combined(with: .opacity))
                        
                        Text(name)
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(EllipticalGradient(colors:[.blue, .indigo], center: .center, startRadiusFraction: 0.0, endRadiusFraction: 0.5))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                // Name Input
                TextField("Enter name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .accessibilityIdentifier("nameInput")
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                // Birthday Image and Candle
                ZStack(alignment: .center) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 220)
                        .colorInvert()
                        .overlay(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.cyan, Color.purple]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                            .blendMode(.overlay)
                        )

                    
                    // Candle positioned at the top of the cake
                    CakeView(isCandleLit: $isCandleLit)
                        .frame(width: 50, height: 50) // Constrain candle size
                        .offset(y: -20) // Adjust this value to position the candle
                }
                .frame(height: 300)
                
                // Controls
                HStack(spacing: 20) {
                    Button(action: startCelebration) {
                        Image(systemName: "play.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(name.isEmpty ? .gray : .green)
                    }
                    .disabled(name.isEmpty)
                    
                    Button(action: audioManager.pauseMusic) {
                        Image(systemName: "pause.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(audioManager.isPlaying ? .green : .gray)
                    }
                    .disabled(!audioManager.isPlaying)
                    
                    Button(action: stopCelebration) {
                        Image(systemName: "stop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(isCandleLit ? .red : .gray)
                    }
                    .disabled(!isCandleLit)
                    
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.largeTitle)
                            .foregroundColor(name.isEmpty ? .gray : .green)
                    }
                    .disabled(name.isEmpty)
                }
                .padding()
            }
            .padding()
            
            // Confetti overlay
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: ["Celebrate \(name)'s birthday! 🎂"])
        }
    }
    
    private func startCelebration() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isCandleLit = true
            showConfetti = true
            showBirthdayText = true
        }
        audioManager.playMusic()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            withAnimation {
                showConfetti = false
            }
        }
    }
    
    private func stopCelebration() {
        withAnimation {
            isCandleLit = false
            showConfetti = false
            showBirthdayText = false
        }
        audioManager.stopMusic()
    }
}

#Preview {
    ContentView()
}
