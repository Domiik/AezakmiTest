//
//  ResetPasswordViewModel.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 15.09.2024.
//

import SwiftUI
import FirebaseAuth

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Пожалуйста, введите email"
            showAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.alertMessage = "Ошибка: \(error.localizedDescription)"
            } else {
                self?.alertMessage = "Ссылка для восстановления пароля отправлена!"
            }
            self?.showAlert = true
        }
    }
}
