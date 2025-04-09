import Foundation

struct AudioStem: Identifiable {
    let id = UUID()
    let name: String
    let fileName: String
    var volume: Float
    var isMuted: Bool
    
    init(name: String, fileName: String, volume: Float = 1.0, isMuted: Bool = false) {
        self.name = name
        self.fileName = fileName
        self.volume = volume
        self.isMuted = isMuted
    }
} 