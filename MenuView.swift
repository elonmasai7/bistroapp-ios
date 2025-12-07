import SwiftUI

struct MenuView: View {
    @StateObject private var firebaseService = FirebaseService()
    @State private var menuItems: [MenuItem] = []
    @State private var cart: [OrderItem] = []
    @State private var selectedCategory = "All"
    @State private var showingCart = false
    
    let categories = ["All", "Appetizers", "Mains", "Desserts", "Drinks"]
    
    var filteredItems: [MenuItem] {
        if selectedCategory == "All" {
            return menuItems
        }
        return menuItems.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                Text(category)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == category ? Color.red : Color.gray.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Menu Items
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredItems) { item in
                            MenuItemRow(item: item) { customization in
                                // Add to cart logic
                                let orderItem = OrderItem(
                                    menuItemID: item.id ?? "",
                                    name: item.name,
                                    price: item.price,
                                    quantity: 1,
                                    customizations: customization
                                )
                                cart.append(orderItem)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Menu")
            .navigationBarItems(trailing: cartButton)
            .onAppear {
                Task {
                    do {
                        menuItems = try await firebaseService.getMenu()
                    } catch {
                        print("Error loading menu: \(error)")
                    }
                }
            }
            .sheet(isPresented: $showingCart) {
                CartView(cart: $cart)
            }
        }
    }
    
    private var cartButton: some View {
        Button(action: { showingCart = true }) {
            ZStack {
                Image(systemName: "cart")
                    .foregroundColor(.white)
                if !cart.isEmpty {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 18, height: 18)
                        .overlay(Text("\(cart.count)").font(.caption).foregroundColor(.white))
                        .offset(x: 10, y: -10)
                }
            }
        }
    }
}

// MARK: - MenuItemRow
struct MenuItemRow: View {
    let item: MenuItem
    let onCustomize: (String?) -> Void
    
    @State private var showingCustomize = false
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.imageURL)) { image in
                image.resizable()
            } placeholder: {
                Rectangle().fill(Color.gray.opacity(0.3))
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name).font(.headline)
                Text(item.description).font(.subheadline).foregroundColor(.gray)
                HStack {
                    Text("$\(item.price, specifier: "%.2f")")
                        .font(.title3).fontWeight(.bold)
                    Spacer()
                    if item.isVegan { Image(systemName: "leaf.fill").foregroundColor(.green) }
                    if item.isGlutenFree { Image(systemName: "wheat.slash.fill").foregroundColor(.blue) }
                }
            }
            
            Spacer()
            
            Button("Customize") {
                showingCustomize = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .sheet(isPresented: $showingCustomize) {
            CustomizeView(item: item) { customization in
                onCustomize(customization)
                showingCustomize = false
            }
        }
    }
}