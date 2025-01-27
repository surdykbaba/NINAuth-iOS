//
//  CustomFont.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct CustomFont: ViewModifier {
    var textStyle: TextStyle
    var fontSize: CGFloat

    var name: String {
        switch textStyle {
        case .largeTitle:
            "PlusJakartaSans-ExtraBold"
        case .title:
            "PlusJakartaSans-Bold"
        case .body:
            "PlusJakartaSans-Regular"
        case .headline:
            "PlusJakartaSans-SemiBold"
        case .subheadline:
            "PlusJakartaSans-Medium"
        case .caption:
            "PlusJakartaSans-Light"
        case .caption2:
            "PlusJakartaSans-ExtraLight"
        }
    }

    var relative: Font.TextStyle {
        switch textStyle {
        case .largeTitle:
                .largeTitle
        case .title:
                .title
        case .body:
                .body
        case .headline:
                .headline
        case .subheadline:
                .subheadline
        case .caption:
                .caption
        case .caption2:
                .caption2
        }
    }

    func body(content: Content) -> some View {
        content.font(.custom(name, size: fontSize, relativeTo: relative))
    }
}

extension View {
    func customFont(_ textStyle: TextStyle, fontSize: CGFloat) -> some View {
        modifier(CustomFont(textStyle: textStyle, fontSize: fontSize))
    }
}

enum TextStyle {
    case largeTitle
    case title
    case body
    case headline
    case subheadline
    case caption
    case caption2
}
