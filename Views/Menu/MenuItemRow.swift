import SwiftUI
import CoreHaptics

struct MenuItemRow: View {
    let item: MenuItem
    let onCustomize: () -> Void
    
    @State private var isPressed = false
    private let engine = try? CHHapticEngine()
    
    var body: some View {
        HStack(spacing: 16) {
            // Image
            AsyncImage(url: URL(string: item.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color(.systemGray5))
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
            
            // Details
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Price & Dietary Icons
                HStack(spacing: 8) {
                    Text("$\(item.price, specifier: "%.2f")")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if item.isVegan {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                            .help("Vegan")
                    }
                    if item.isGlutenFree {
                        Image(systemName: "wheat.slash.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                            .help("Gluten-Free")
                    }
                    if item.containsNuts {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                            .help("Contains Nuts")
                    }
                }
            }
            
            Spacer()
            
            // Customize Button
            Button(action: {
                triggerHaptic()
                withAnimation(.easeOut(duration: 0.2)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                    onCustomize()
                }
            }) {
                Text("Customize")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color("Primary"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .buttonStyle(PlainButtonStyle()) // Prevents default iOS button styling
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onAppear {
            prepareHaptics()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(item.name), \(item.description), price $\(item.price)")
        .accessibilityAddTraits(.isButton)
    }
    
    private func prepareHaptics() {
        guard let engine = engine else { return }
        do {
            try engine.start()
        } catch {
            print("Failed to start haptic engine: \(error)")
        }
    }
    
    private func triggerHaptic() {
        guard let engine = engine else { return }
        let impact = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)],
            relativeTime: 0
        )
        do {
            let pattern = try CHHapticPattern(events: [impact], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error)")
        }
    }
}

// MARK: - Data Model (Add to Models.swift if not present)
struct MenuItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let description: String
    let price: Double
    let category: String
    let isVegan: Bool
    let isGlutenFree: Bool
    let containsNuts: Bool
    let imageURL: String
}