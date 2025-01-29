//
//  CustomTextField.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct CustomTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(15)
            .background(.white)
            .mask(
                RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke()
                .fill(.gray)
            )
    }
}

extension View {
    func customTextField() -> some View {
        modifier(CustomTextField())
    }
}
