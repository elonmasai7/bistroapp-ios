import SwiftUI

struct OrderTrackingView: View {
    let order: Order
    @State private var currentTime: Date = Date()
    
    private let statuses: [OrderStatus] = [.received, .preparing, .ready, .delivered]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Timeline
                VStack(spacing: 24) {
                    ForEach(statuses.indices, id: \.self) { index in
                        TimelineStep(
                            status: statuses[index],
                            isCurrent: order.status == statuses[index],
                            isCompleted: statuses.firstIndex(of: order.status)! > index
                        )
                        
                        if index < statuses.count - 1 {
                            TimelineConnector(
                                isCompleted: statuses.firstIndex(of: order.status)! > index
                            )
                        }
                    }
                }
                .padding(.vertical)
                
                // Estimated Time
                if order.status != .delivered {
                    VStack {
                        Text("Estimated time")
                            .font(.headline)
                        Text("\(estimatedMinutes) min")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color("Primary"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Primary").opacity(0.1))
                    .cornerRadius(16)
                }
                
                // Live Map (if delivery)
                if order.serviceType == .delivery && order.status != .delivered {
                    MapView()
                        .frame(height: 200)
                        .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationTitle("Order Tracking")
    }
    
    private var estimatedMinutes: Int {
        switch order.status {
        case .received: return 15
        case .preparing: return 10
        case .ready: return 5
        default: return 0
        }
    }
}

// MARK: - Timeline Components
struct TimelineStep: View {
    let status: OrderStatus
    let isCurrent: Bool
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(isCompleted ? .green : (isCurrent ? Color("Primary") : .gray.opacity(0.3)))
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                } else if isCurrent {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(status.rawValue)
                    .font(.headline)
                if isCurrent {
                    Text("In progress...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct TimelineConnector: View {
    let isCompleted: Bool
    
    var body: some View {
        Rectangle()
            .frame(width: 2, height: 24)
            .foregroundColor(isCompleted ? .green : .gray.opacity(0.3))
            .padding(.leading, 15)
    }
}