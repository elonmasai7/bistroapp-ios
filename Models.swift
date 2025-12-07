import Foundation
import FirebaseFirestoreSwift

struct MenuItem: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let description: String
    let price: Double
    let category: String
    let isVegan: Bool
    let isGlutenFree: Bool
    let imageURL: String
}

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    let userID: String
    let items: [OrderItem]
    let total: Double
    let serviceType: ServiceType
    let status: OrderStatus
    let timestamp: Timestamp
    var tableNumber: Int? // For dine-in
}

struct OrderItem: Identifiable, Codable {
    var id = UUID()
    let menuItemID: String
    let name: String
    let price: Double
    let quantity: Int
    let customizations: String?
}

enum ServiceType: String, Codable, CaseIterable {
    case dineIn = "Dine-In"
    case takeout = "Takeout"
    case delivery = "Delivery"
}

enum OrderStatus: String, Codable, CaseIterable {
    case received = "Received"
    case preparing = "Preparing"
    case ready = "Ready"
    case delivered = "Delivered"
}