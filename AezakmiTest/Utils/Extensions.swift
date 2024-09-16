//
//  Extensions.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//

import SwiftUI

struct ButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .frame(width: 300, height: 60)
            .background(Color.blue)
            .cornerRadius(10.0)
            .font(.headline)
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(ButtonStyleModifier())
    }
}

public extension View {
    #if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif
}
