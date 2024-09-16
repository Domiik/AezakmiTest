//
//  FirebaseAuthenticationService.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//

import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

protocol AuthenticationServiceProtocol {
    func login(with loginOption: LoginOption, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signInWithGoogle(completion: @escaping (Result<Void, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
}


final class AuthenticationService: AuthenticationServiceProtocol {
    func login(with loginOption: LoginOption, completion: @escaping (Result<Void, Error>) -> Void) {
        switch loginOption {
        case let .emailAndPassword(email, password):
            signInWithEmail(email: email, password: password, completion: completion)
        case .signInWithGoogle:
            signInWithGoogle(completion: completion)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signInWithGoogle(completion: @escaping (Result<Void, Error>) -> Void) {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.authenticateGoogleUser(for: user, completion: completion)
                }
            }
        } else {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { user, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.authenticateGoogleUser(for: user?.user, completion: completion)
                }
            }
        }
    }
    
    private func authenticateGoogleUser(for user: GIDGoogleUser?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let idToken = user?.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user?.accessToken.tokenString ?? "")
        
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
