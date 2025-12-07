import SwiftUI

struct HomeView: View {
    @StateObject private var menuService = MenuService()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Hero Banner
                    HeroBannerView()
                        .frame(height: 200)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                    
                    // Primary CTAs
                    HStack(spacing: 16) {
                        PrimaryButton(title: "Order Now", systemImage: "cart") {
                            // Navigate to Menu
                        }
                        PrimaryButton(title: "Reserve Table", systemImage: "calendar") {
                            // Navigate to Reservations
                        }
                    }
                    .padding(.horizontal)
                    
                    // Favorites Section
                    if !menuService.favorites.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Favorites")
                                .font(.title2.bold())
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(menuService.favorites) { item in
                                        NavigationLink(destination: ItemDetailView(item: item)) {
                                            FavoriteItemCard(item: item)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Restaurant Info
                    RestaurantInfoView()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(radius: 2)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationTitle("Bistro")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                Task { await menuService.loadMenu() }
            }
        }
    }
}

// MARK: - Reusable Components
struct HeroBannerView: View {
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://example.com/hero.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(Color("Primary").opacity(0.7))
            }
            VStack {
                Text("20% OFF PASTA NIGHT!")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
                Button("Order Now") {
                    // Action
                }
                .buttonStyle(WhiteButtonStyle())
            }
        }
    }
}

struct PrimaryButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("Primary"))
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}