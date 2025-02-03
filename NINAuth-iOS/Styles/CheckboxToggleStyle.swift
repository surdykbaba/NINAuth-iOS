//
//  CheckboxToggleStyle.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack(spacing: 15) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .foregroundColor(configuration.isOn ? Color.button : Color.grayTextBackground.opacity(0.3))
                .cornerRadius(4)
                .frame(width: 22, height: 22)
                .customFont(.caption2, fontSize: 0.5)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}
