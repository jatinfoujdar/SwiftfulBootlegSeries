import UIKit

class HapticManager {
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    init() {
        // Prepare the generators
        impactGenerator.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    func playImpact() {
        impactGenerator.impactOccurred()
        impactGenerator.prepare()
    }
    
    func playSuccess() {
        notificationGenerator.notificationOccurred(.success)
        notificationGenerator.prepare()
    }
    
    func playWarning() {
        notificationGenerator.notificationOccurred(.warning)
        notificationGenerator.prepare()
    }
    
    func playError() {
        notificationGenerator.notificationOccurred(.error)
        notificationGenerator.prepare()
    }
    
    func playSelection() {
        selectionGenerator.selectionChanged()
        selectionGenerator.prepare()
    }
} 