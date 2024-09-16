//
//  TextModel.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 16.09.2024.
//

import SwiftUI

struct TextModel: Identifiable {
    
    var id = UUID().uuidString
    var text: String = ""
    var size: Int = 0
    var font: String = ""
    var textColor: UIColor = .black
    
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    
    var isAdded: Bool = false
    
    
    var swiftUIColor: Color {
        get {
            Color(textColor)
        }
        set {
            textColor = UIColor(newValue)
        }
    }
}
