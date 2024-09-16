//
//  RegistrationView.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 13.09.2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    
    var body: some View {
        VStack {
            Text("Регистрация")
                .font(.largeTitle)
                .padding()
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                viewModel.checkEmailUniqueness { isUnique in
                    if isUnique {
                        viewModel.registerUser()
                    }
                }
            })
            {
                Text("Регистрация")
                    .buttonStyle()
            }
            .padding()
            .padding()
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.checkEmailVerificationStatus()
        }
    }
}


#Preview {
    RegistrationView()
}
