import SwiftUI

struct OrderDetailsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Header
            Text("ORDER DETAILS")
                .font(.headline)
                .padding(.bottom, 8)

            // Pizza info row
            HStack(alignment: .top) {
                Image("p1") // Add a pizza image named "pizza" in Assets
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Chicken Pizza")
                        .font(.headline)
                    
                    Text("₹180 | Hand tossed")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // Add customisation action
                    }) {
                        Text("+ Customise")
                            .font(.footnote)
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                // Quantity Stepper
                HStack {
                    Button(action: {}) {
                        Image(systemName: "minus")
                    }
                    Text("1")
                        .frame(minWidth: 20)
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
                .padding(6)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }

            Divider()
            
            // Pricing details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Chicken pizza")
                    Spacer()
                    Text("₹180.00")
                }
                
                HStack {
                    Text("Taxes")
                    Spacer()
                    Text("₹40")
                }
                
                HStack {
                    Text("Packing charges")
                    Spacer()
                    Text("₹0.0")
                }

                HStack {
                    Text("Coupon 'FIRST ₹100'")
                        .foregroundColor(.green)
                    Spacer()
                    Text("– ₹100")
                        .foregroundColor(.green)
                }
            }
            .font(.subheadline)
            
            Divider()
            
            // Total
            HStack {
                Text("Total")
                    .font(.headline)
                Spacer()
                Text("₹120")
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
    }
}
