import SwiftUI

struct CouponSection: View {
    let couponCode: String
    let discount: String
    let expiryDate: Date
    @State private var isNew: Bool = true
    
    var body: some View {
        VStack(spacing: 8) {
            if isNew {
                Text("NEW COUPON!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
            }
            
            Text(couponCode)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(discount)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            
            Text("Valid until \(formatDate(expiryDate))")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), 
                          startPoint: .topLeading, 
                          endPoint: .bottomTrailing)
                .cornerRadius(15)
        )
        .shadow(radius: 5)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct RestaurantTimerWidget: View {
    let restaurantName: String
    let closingTime: Date
    @State private var timeRemaining: TimeInterval = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 12) {
            Text(restaurantName)
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Closing in")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            // Time remaining text with conditional color change
            Text(formatTimeRemaining())
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(timeRemaining <= 600 ? .red : .blue)  // Turn red if time is <= 10 minutes
                .animation(.bouncy(duration: 0.2), value: timeRemaining) // Optional: Add smooth transition for color change
            
            Text("Closes at \(formatClosingTime())")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(
                   // Linear Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.black]), startPoint: .top, endPoint: .bottom)
                       .cornerRadius(5)
                       .shadow(radius: 5)
               )
        .cornerRadius(15)
        .shadow(radius: 5)
        .onReceive(timer) { _ in
            updateTimeRemaining()
        }
        .onAppear {
            updateTimeRemaining()
        }
    }
    
    private func updateTimeRemaining() {
        let now = Date()
        if now > closingTime {
            // If closing time has passed, set it for tomorrow
            var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: closingTime) ?? closingTime
            timeRemaining = tomorrow.timeIntervalSince(now)
        } else {
            timeRemaining = closingTime.timeIntervalSince(now)
        }
    }
    
    private func formatTimeRemaining() -> String {
        let hours = Int(timeRemaining) / 3600
        let minutes = Int(timeRemaining) / 60 % 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func formatClosingTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: closingTime)
    }
}

struct RushHourSection: View {
    let currentTime = Date()
    let rushHours: [(start: Int, end: Int)] = [(12, 14), (19, 21)] // Lunch and dinner rush
    
    var isRushHour: Bool {
        let hour = Calendar.current.component(.hour, from: currentTime)
        return rushHours.contains { start, end in
            hour >= start && hour < end
        }
    }
    
    var nextRushHour: (start: Int, end: Int)? {
        let hour = Calendar.current.component(.hour, from: currentTime)
        return rushHours.first { start, _ in start > hour }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: isRushHour ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .foregroundColor(isRushHour ? .yellow : .green)
                
                Text(isRushHour ? "Rush Hour" : "Good Time to Order")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            if isRushHour {
                Text("Expect longer wait times")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            } else if let nextRush = nextRushHour {
                Text("Next rush hour starts at \(nextRush.start):00")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), 
                          startPoint: .topLeading, 
                          endPoint: .bottomTrailing)
                .cornerRadius(15)
        )
        .shadow(radius: 5)
    }
}

struct ContentView: View {
    // Demo restaurant data (set closing time to 10 minutes from now)
    let restaurant = RestaurantTimerWidget(
        restaurantName: "The Rameshwaram Cafe",
        closingTime: Date().addingTimeInterval(10 * 60)  // 10 minutes from now
    )
    
    // Demo coupon data
    let coupon = CouponSection(
        couponCode: "SAVE20",
        discount: "20% OFF on all orders",
        expiryDate: Date().addingTimeInterval(7 * 24 * 60 * 60) // 7 days from now
    )
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Final Call: Order Before We Close!")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            restaurant
                .padding(.horizontal)
            
            Divider()
                .background(Color.white.opacity(0.3))
                .padding(.vertical, 10)
            
            Text("Order Timing")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            RushHourSection()
                .padding(.horizontal)
            
            Divider()
                .background(Color.white.opacity(0.3))
                .padding(.vertical, 10)
            
            Text("Special Offers")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            coupon
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
