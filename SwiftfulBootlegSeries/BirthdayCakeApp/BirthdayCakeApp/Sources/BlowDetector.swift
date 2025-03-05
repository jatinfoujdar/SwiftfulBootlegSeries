import Foundation
import AVFoundation
import AVFAudio

class BlowDetector: ObservableObject {
    private let audioEngine = AVAudioEngine()
    private let threshold: Float = 0.1 // Adjust this value based on testing
    @Published var isBlowing = false
    
    func startMonitoring(onBlow: @escaping (Bool) -> Void) {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            guard let self = self else { return }
            
            let channelData = buffer.floatChannelData?[0]
            let frameLength = UInt(buffer.frameLength)
            
            var maxAmplitude: Float = 0
            for i in 0..<frameLength {
                let sample = abs(channelData?[Int(i)] ?? 0)
                maxAmplitude = max(maxAmplitude, sample)
            }
            
            DispatchQueue.main.async {
                let isBlowing = maxAmplitude > self.threshold
                self.isBlowing = isBlowing
                onBlow(isBlowing)
            }
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    func stopMonitoring() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    deinit {
        stopMonitoring()
    }
} 