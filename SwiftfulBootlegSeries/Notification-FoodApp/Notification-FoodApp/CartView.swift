import SwiftUI
import UserNotifications

// MARK: - Notification Manager

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    let savageMessages = [
        "ab pata chala tum sab single kyun ho 🤨",
        "khud ki zindagi me taste nahi, food delete kar rahe ho 😒",
        "food delete karna = bad vibes only 🚫",
        "tumse na ho payega 🍽️",
        "emotional damage detected 🧠",
        "tumhe dekh ke toh pizza bhi thanda pad gaya 🍕🥶",
        "khana delete karne walon ka toh rab hi malik hai 😔",
        "jo biryani ko ignore kare, usse toh block hi kar do 🚫🍛",
        "khud bhi boring, plate bhi boring banate ho 😑",
        "fridge khol ke drama, plate se karte ho karma 🍽️💔",
        "mood off ka solution khana hai, na ki usse delete karna 😤",
        "tum logon ke plate me taste bhi resignation de chuka hai 🤧",
        "tandoori ne kaha: 'main jaa rahi hoon, mujhe tumse dar lagta hai' 😢🔥",
        "khaane ko reject karna = toxic behavior confirmed ☠️",
        "zindagi ka spice missing hai, kyunki tum delete button pe ho 🌶️❌"
    ]
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func sendRandomSavageNotification() {
        let content = UNMutableNotificationContent()
        content.title = "⚠️ Food Deleted! ⚠️"
        content.body = savageMessages.randomElement() ?? "Default message"
        content.sound = .default
        content.interruptionLevel = .timeSensitive
        content.categoryIdentifier = "FOOD_DELETED"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Savage notification scheduled successfully")
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

// MARK: - FoodItem Model

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    var quantity: Int
    let imageName: String
}

// MARK: - CartView

struct CartView: View {
    @State private var selectedDeliveryOption = "Standard"
    @State private var totalAmount: Double = 140
    @State private var foodItems = [
        FoodItem(name: "Burger", price: 120, quantity: 1, imageName: "b1"),
        FoodItem(name: "Pizza", price: 200, quantity: 1, imageName: "p2"),
        FoodItem(name: "Fries", price: 80, quantity: 1, imageName: "f1"),
        FoodItem(name: "Chicken Pizza", price: 180, quantity: 1, imageName: "p1")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text("ORDER DETAILS")
                .font(.headline)
                .padding(.bottom, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(foodItems.enumerated()), id: \.element.id) { index, item in
                        HStack(alignment: .top, spacing: 12) {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline)
                                Text("₹\(item.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Button(action: {}) {
                                    Text("+ Customise")
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    if foodItems[index].quantity > 1 {
                                        foodItems[index].quantity -= 1
                                        NotificationManager.shared.sendRandomSavageNotification()
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                
                                Text("\(foodItems[index].quantity)")
                                    .frame(minWidth: 20)
                                
                                Button(action: {
                                    foodItems[index].quantity += 1
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Delivering superfast!")
                        .font(.headline)
                    
                    DeliveryOptionView(
                        title: "Standard",
                        description: "Minimal order grouping",
                        time: "20-25 mins",
                        isSelected: selectedDeliveryOption == "Standard",
                        action: { selectedDeliveryOption = "Standard" }
                    )
                    
                    DeliveryOptionView(
                        title: "Eco Saver",
                        description: "Lesser CO2 by order grouping",
                        time: "25-30 mins",
                        isSelected: selectedDeliveryOption == "Eco Saver",
                        action: { selectedDeliveryOption = "Eco Saver" }
                    )
                }
                .padding()
            }
            
            VStack(spacing: 10) {
                HStack {
                    Text("To Pay")
                        .font(.headline)
                    Spacer()
                    Text("₹165")
                        .font(.subheadline)
                        .strikethrough()
                        .foregroundColor(.gray)
                    Text("₹120")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("₹25 saved!")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Spacer()
                }
                
                Button(action: {}) {
                    Text("Pay ₹120")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
}

// MARK: - DeliveryOptionView

struct DeliveryOptionView: View {
    let title: String
    let description: String
    let time: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Circle()
                    .stroke(isSelected ? Color.green : Color.gray, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(isSelected ? Color.green : Color.clear)
                            .frame(width: 12, height: 12)
                    )

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.subheadline)
                        .bold()
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()
                Text(time)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    CartView()
}
