//
//  GoogleLogin.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//

import SwiftUI

struct GoogleLogin: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        
        GoogleSignInButton()
            .frame(width: 210, height: 40)
            .padding(.bottom, 20)
            .onTapGesture {
                hideKeyboard()
                    authViewModel.login(with: .signInWithGoogle)
            }
    }
}


