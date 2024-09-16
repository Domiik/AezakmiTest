//
//  AuthenticationViewModel.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

enum LoginOption: Equatable {
    case signInWithGoogle
    case emailAndPassword(email: String, password: String)
}

final class AuthenticationViewModel: NSObject, ObservableObject {
    
    enum State {
        case idle
        case loading
        case end
    }
    
    @Published var alertItem: APError?
    @Published private(set) var stateView = State.idle
    @Published var errorMessage: String = ""
    @Published var restoreGoogleSignIn: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var showInvalidPWAlert: Bool = false
    @Published var isEmailValid: Bool = false
    @Published var isPasswordValid: Bool = false
    @Published var isEmailFieldActive: Bool = false
    @Published var isPasswordFieldActive: Bool = false
    private let authService: AuthenticationServiceProtocol
    
    init(authService: AuthenticationServiceProtocol) {
        self.authService = authService
        super.init()
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            restoreGoogleSignIn = true
        }
        stateView = .end
    }
    
    // Email validation using regex
    func validateEmail(_ email: String) {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
    }
    
    // Password validation for minimum length
    func validatePassword(_ password: String) {
        isPasswordValid = password.count >= 6
    }
    
    func login(with loginOption: LoginOption) {
        self.stateView = .loading
        authService.login(with: loginOption) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isAuthenticated = true
                    self?.stateView = .end
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showInvalidPWAlert = true
                    self?.stateView = .end
                }
            }
        }
    }
    
    func signUp(email: String, password: String) {
        self.stateView = .loading
        authService.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.stateView = .end
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                self?.stateView = .end
            }
        }
    }
    
    func signOut() {
        authService.signOut { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.restoreGoogleSignIn = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
