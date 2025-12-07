import SwiftUI
import AuthenticationServices
import CoreLocation

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingEmailForm = false
    @State private var locationManager = CLLocationManager()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // App Logo
                    Image("app-logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                    
                    Text("Welcome to Bistro")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Text("Sign in to order food, track rewards, and save your favorites.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Apple Sign In
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            Task {
                                await authService.handleAppleSignIn(result: result)
                                if authService.isAuthenticated {
                                    dismiss()
                                }
                            }
                        }
                    )
                    .frame(height: 52)
                    .signInWithAppleButtonStyle(.black)
                    .buttonStyle(ScaleButtonStyle())
                    
                    // Google Sign In (Placeholder — integrate GoogleSignIn SDK in real app)
                    Button {
                        // In production: authService.signInWithGoogle()
                        // For demo, simulate success
                        Task { await authService.signIn(email: "demo@example.com", password: "password") }
                    } label: {
                        HStack {
                            Image(systemName: "g.circle")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Continue with Google")
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.white)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    // Email Login Toggle
                    Button {
                        withAnimation {
                            showingEmailForm.toggle()
                        }
                    } label: {
                        Text("Sign in with email")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    
                    // Email Form (Animated Reveal)
                    if showingEmailForm {
                        EmailLoginForm(
                            email: $email,
                            password: $password,
                            onSignIn: {
                                Task {
                                    await authService.signIn(email: email, password: password)
                                    if authService.isAuthenticated {
                                        dismiss()
                                    }
                                }
                            }
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .onAppear {
                            requestPermissions()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
            }
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func requestPermissions() {
        // Request Notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        
        // Request Location (for delivery)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - Email Login Form
struct EmailLoginForm: View {
    @Binding var email: String
    @Binding var password: String
    let onSignIn: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .accessibilityLabel("Email address")
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .accessibilityLabel("Password")
            
            Button("Forgot password?") {
                // Handle password reset
            }
            .font(.caption)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Button(action: onSignIn) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Primary"))
                    .cornerRadius(12)
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(email.isEmpty || password.isEmpty)
        }
        .padding(.top, 12)
    }
}

// MARK: - Location Manager Delegate
extension LoginView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle location permission result if needed
    }
}