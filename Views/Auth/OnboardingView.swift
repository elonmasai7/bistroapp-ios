import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var showingLogin = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image("app-logo")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    
                    Text("Welcome to BistroApp")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    
                    // Apple Sign In
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        Task {
                            await authService.handleAppleSignIn(result: result)
                        }
                    }
                    .frame(height: 50)
                    .signInWithAppleButtonStyle(.black)
                    .scaleEffect(showingLogin ? 1.0 : 0.95)
                    .animation(.easeInOut(duration: 0.2), value: showingLogin)
                    
                    // Google Sign In (use GoogleSignIn SDK in real app)
                    Button {
                        // Google sign-in logic
                    } label: {
                        HStack {
                            Image("google-logo")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Continue with Google")
                                .fontWeight(.medium)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    // Email Login Toggle
                    Button("Sign in with email") {
                        showingLogin.toggle()
                    }
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    
                    if showingLogin {
                        EmailLoginView(email: $email, password: $password)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: 500)
            }
            .navigationDestination(isPresented: $authService.isAuthenticated) {
                HomeView()
            }
            .onAppear {
                // Request permissions
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    private var locationManager: CLLocationManager {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return manager
    }
}

// MARK: - Email Login Form
struct EmailLoginView: View {
    @Binding var email: String
    @Binding var password: String
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            Button("Forgot password?") {
                // Handle password reset
            }
            .font(.caption)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Button("Sign In") {
                Task { await authService.signIn(email: email, password: password) }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("Primary"))
            .foregroundColor(.white)
            .cornerRadius(12)
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.top, 8)
    }
}