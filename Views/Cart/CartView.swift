import SwiftUI
import CoreHaptics

struct CartView: View {
    @Binding var cart: [CartItem]
    @Environment(\.dismiss) var dismiss
    @State private var serviceType: ServiceType = .dineIn
    @State private var tableNumber = ""
    @State private var specialRequest = ""
    @State private var isProcessing = false
    
    private let engine = try? CHHapticEngine()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Your Order") {
                    ForEach($cart, id: \.id) { $item in
                        CartItemRow(cartItem: $item)
                    }
                }
                
                Section("How would you like your order?") {
                    Picker("Service Type", selection: $serviceType) {
                        ForEach(ServiceType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if serviceType == .dineIn {
                        TextField("Table Number", text: $tableNumber)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section("Special Requests") {
                    TextEditor(text: $specialRequest)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Section("Total: $\(total, specifier: "%.2f")") {
                    Button("Proceed to Checkout") {
                        triggerHaptic()
                        // Handle checkout
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Primary"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(isProcessing || cart.isEmpty)
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .onAppear {
            prepareHaptics()
        }
    }
    
    private var total: Double {
        cart.reduce(0) { $0 + ($1.menuItem.price * Double($1.quantity)) }
    }
    
    private func prepareHaptics() {
        guard let engine = engine else { return }
        do {
            try engine.start()
        } catch {
            print("Haptic engine failed to start: \(error)")
        }
    }
    
    private func triggerHaptic() {
        let generator = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [],
            relativeTime: 0
        )
        let pattern = try? CHHapticPattern(events: [generator], parameters: [])
        let player = try? engine?.makePlayer(with: pattern!)
        try? player?.start(atTime: 0)
    }
}