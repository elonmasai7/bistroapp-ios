import SwiftUI

struct MenuView: View {
    @StateObject private var menuService = MenuService()
    @State private var selectedCategory = "All"
    @Namespace private var animation
    
    let categories = ["All", "Appetizers", "Mains", "Desserts", "Drinks"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Sticky Category Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                withAnimation {
                                    selectedCategory = category
                                }
                            } label: {
                                VStack {
                                    Text(category)
                                        .font(.subheadline)
                                        .fontWeight(selectedCategory == category ? .bold : .regular)
                                        .foregroundColor(selectedCategory == category ? Color("Primary") : .gray)
                                    
                                    if selectedCategory == category {
                                        Rectangle()
                                            .frame(width: 40, height: 2)
                                            .foregroundColor(Color("Primary"))
                                            .matchedGeometryEffect(id: "underline", in: animation)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color(.systemBackground))
                .shadow(radius: 2)
                
                // Menu Items
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredItems) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                MenuItemRow(item: item)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Menu")
            .onAppear {
                Task { await menuService.loadMenu() }
            }
        }
    }
    
    var filteredItems: [MenuItem] {
        guard selectedCategory != "All" else { return menuService.menuItems }
        return menuService.menuItems.filter { $0.category == selectedCategory }
    }
}