import SwiftUI

struct CartView: View {
    @Binding var cart: [OrderItem]
    @Environment(\.dismiss) var dismiss
    @State private var serviceType: ServiceType = .dineIn
    @State private var tableNumber = ""
    @State private var specialRequest = ""
    @State private var isProcessing = false
    
    var total: Double {
        cart.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Order Summary") {
                    ForEach(cart) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                        }
                    }
                }
                
                Section("Service Type") {
                    Picker("Type", selection: $serviceType) {
                        ForEach(ServiceType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if serviceType == .dineIn {
                        TextField("Table Number", text: $tableNumber)
                    }
                }
                
                Section("Special Requests") {
                    TextEditor(text: $specialRequest)
                        .frame(height: 80)
                }
                
                Section("Total") {
                    HStack {
                        Spacer()
                        Text("Total: $\(total, specifier: "%.2f")")
                            .font(.title2).fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Checkout") {
                        Task { await placeOrder() }
                    }
                    .disabled(isProcessing || cart.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func placeOrder() async {
        isProcessing = true
        defer { isProcessing = false }
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        var order = Order(
            userID: userID,
            items: cart,
            total: total,
            serviceType: serviceType,
            status: .received,
            timestamp: .init()
        )
        
        if serviceType == .dineIn, let table = Int(tableNumber) {
            order.tableNumber = table
        }
        
        do {
            // Save to Firebase
            try await FirebaseService().placeOrder(order)
            
            // Show success & reset
            await MainActor.run {
                cart.removeAll()
                dismiss()
                // Show order confirmation screen (omitted for brevity)
            }
        } catch {
            await MainActor.run {
                // Show error alert
                print("Checkout failed: \(error)")
            }
        }
    }
}