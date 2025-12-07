import SwiftUI

struct ProfileView: View {
    @StateObject private var profileService = ProfileService()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            List {
                // Loyalty Section
                Section {
                    VStack(spacing: 16) {
                        Text("Loyalty Points")
                            .font(.headline)
                        
                        // Progress Bar
                        HStack {
                            Text("\(profileService.points)")
                                .font(.title2.bold())
                                .foregroundColor(Color("Primary"))
                            
                            Spacer()
                            
                            Text("\(profileService.points)/100")
                        }
                        
                        ProgressView(value: Double(profileService.points), total: 100.0)
                            .tint(Color("Primary"))
                            .progressViewStyle(LinearProgressViewStyle())
                        
                        Text("3 more orders for a free dessert!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .listRowBackground(Color.clear)
                }
                
                // Order History
                Section("Order History") {
                    ForEach(profileService.orderHistory) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderHistoryRow(order: order)
                        }
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings") {
                        showingSettings = true
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .refreshable {
                await profileService.loadOrders()
            }
        }
    }
}