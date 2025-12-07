import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        if isAuthenticated {
            TabView {
                MenuView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                OrderTrackingView()
                    .tabItem {
                        Image(systemName: "clock")
                        Text("Orders")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
        } else {
            OnboardingView { success in
                isAuthenticated = success
            }
        }
    }
}