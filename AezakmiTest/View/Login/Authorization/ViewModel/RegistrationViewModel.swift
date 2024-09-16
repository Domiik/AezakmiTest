//
//  RegistrationViewModel.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 15.09.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isEmailVerified = false

    private let db = Firestore.firestore()


    func checkEmailUniqueness(completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = "Ошибка проверки уникальности электронной почты: \(error.localizedDescription)"
                completion(false)
            } else if snapshot?.documents.count == 0 {
                completion(true)
            } else {
                self.errorMessage = "Этот адрес уже зарегистрирован."
                completion(false)
            }
        }
    }

    // Регистрация пользователя
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                guard let user = authResult?.user else { return }
                let userData = ["email": self.email]
                self.db.collection("users").document(user.uid).setData(userData)
                self.sendEmailVerification(user: user)
            }
        }
    }

    // Отправка письма для подтверждения email
    func sendEmailVerification(user: User) {
        user.sendEmailVerification { error in
            if let error = error {
                self.errorMessage = "Ошибка отправки подтверждения по электронной почте: \(error.localizedDescription)"
            } else {
                self.errorMessage = "Письмо с подтверждением отправлено. Пожалуйста, проверьте свой почтовый ящик."
            }
        }
    }

    // Проверка, подтвержден ли email
    func checkEmailVerificationStatus() {
        Auth.auth().currentUser?.reload { error in
            if let error = error {
                self.errorMessage = "Ошибка подтверждения пользователя \(error.localizedDescription)"
            } else {
                self.isEmailVerified = Auth.auth().currentUser?.isEmailVerified ?? false
            }
        }
    }
}

