//
//  LoginButton.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//

import SwiftUI
import FirebaseAuth

struct LoginButton: View {
    @Binding var emailAddress: String
    @Binding var password: String
    @Binding var showInvalidPWAlert: Bool
    @Binding var isAuthenticated: Bool
    @ObservedObject var authViewModel: AuthenticationViewModel

    var body: some View {
        Button(action: {
            authViewModel.login(with: .emailAndPassword(email: emailAddress, password: password))
        }) {
            Text("Войти")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(authViewModel.isEmailValid && authViewModel.isPasswordValid ? Color.blue : Color.gray) // Если данные валидны — синий цвет, иначе серый
                .cornerRadius(10)
        }
        .disabled(!(authViewModel.isEmailValid && authViewModel.isPasswordValid)) // Отключение кнопки при неверной валидации
        .alert(isPresented: $showInvalidPWAlert) {
            Alert(title: Text("Email или пароль некорректны"))
        }
    }
}

