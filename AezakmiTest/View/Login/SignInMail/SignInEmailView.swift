//
//  SignInEmailView.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 13.09.2024.
//

import SwiftUI

struct SignInEmailView: View {
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var showAuthLoader: Bool = false
    @State private var showInvalidPWAlert: Bool = false
    @State private var isAuthenticated: Bool = false
    @StateObject private var coordinator = AuthCoordinator()
    @StateObject private var authViewModel = AuthenticationViewModel(authService: AuthenticationService())
    
    var body: some View {
        switch authViewModel.stateView {
        case .idle:
            Color.clear.onAppear { }
        case .loading:
            LoadingView()
        case .end:
            NavigationStack(path: $coordinator.path) {
                VStack {
                    Text("Авторизация через Email")
                        .font(.largeTitle)
                        .padding()
                    
                    TextField("Email", text: $emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onChange(of: emailAddress) { newValue in
                            authViewModel.isEmailFieldActive = true 
                            authViewModel.validateEmail(newValue)
                        }
                    
                    SecureField("Пароль", text: $password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onChange(of: password) { newValue in
                            authViewModel.isPasswordFieldActive = true
                            authViewModel.validatePassword(newValue)
                        }
                    if authViewModel.isEmailFieldActive && !authViewModel.isEmailValid {
                        Text("Неверный формат email")
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }
                    
                    if authViewModel.isPasswordFieldActive && !authViewModel.isPasswordValid {
                        Text("Пароль должен содержать минимум 6 символов")
                            .foregroundColor(.red)
                            .padding(5)
                    }
                    
                    
                    LoginButton(emailAddress: $emailAddress, password: $password, showInvalidPWAlert: $showInvalidPWAlert, isAuthenticated: $isAuthenticated, authViewModel: authViewModel)
                        .padding()
                    
                    
                    Button(action: {
                        coordinator.showResetPassword()
                    }) {
                        Text("Забыли пароль?")
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        coordinator.navigate(to: .registration)
                    }) {
                        Text("Регистрация пользователя")
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 5)
                    
                    GoogleLogin(authViewModel: authViewModel, isAuthenticated: $isAuthenticated)
                        .padding(.top, 5)
                    
                }
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .registration:
                        RegistrationView()
                    }
                }
                .sheet(isPresented: $coordinator.isShowingResetPassword) {
                    ResetPasswordView()
                }
                .fullScreenCover(isPresented: $authViewModel.isAuthenticated) {
                    HomeView(authViewModel: authViewModel)
                }
                .alert(isPresented: $authViewModel.showInvalidPWAlert) {
                    Alert(
                        title: Text("Ошибка"),
                        message: Text(authViewModel.errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        
    }
}
