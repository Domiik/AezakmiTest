//
//  LoadingView.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            ProgressView()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
