//
//  ResetPasswordView.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 15.09.2024.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode

        var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Восстановление пароля")
                        .font(.title)
                        .padding()

                    TextField("Введите email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        viewModel.resetPassword()
                    }) {
                        Text("Отправить ссылку для восстановления пароля")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()

                    Spacer()
                }
                .navigationBarTitle("Восстановление пароля", displayMode: .inline)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Сообщение"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("ОК"), action: {
                        if viewModel.alertMessage == "Ссылка для восстановления пароля отправлена!" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }))
                }
                .padding()
            }
        }
}

#Preview {
    ResetPasswordView()
}
