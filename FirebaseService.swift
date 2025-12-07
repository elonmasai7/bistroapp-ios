import Firebase
import FirebaseFirestoreSwift

class FirebaseService: ObservableObject {
    private let db = Firestore.firestore()
    
    // MARK: - Authentication
    func signInWithApple() async throws -> Bool {
        // Apple Sign In implementation (uses ASAuthorizationAppleIDProvider)
        // ... (omitted for brevity; use Firebase Auth docs)
        return true
    }
    
    // MARK: - Menu
    func getMenu() async throws -> [MenuItem] {
        let snapshot = try await db.collection("menu").getDocuments()
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: MenuItem.self)
        }
    }
    
    // MARK: - Orders
    func placeOrder(_ order: Order) async throws {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        var orderToSave = order
        orderToSave.userID = userID
        orderToSave.timestamp = Timestamp(date: Date())
        
        try db.collection("orders").addDocument(from: orderToSave)
        
        // Trigger Cloud Function for notifications
        // (Implemented in Firebase Console)
    }
    
    func getOrders(for userID: String) async throws -> [Order] {
        let snapshot = try await db
            .collection("orders")
            .whereField("userID", isEqualTo: userID)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Order.self)
        }
    }
}