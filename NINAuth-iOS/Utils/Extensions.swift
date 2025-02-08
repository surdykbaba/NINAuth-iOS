//
//  Extensions.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 07/02/2025.
//

import SwiftUI

// Custom Half Sheet Modifier...
extension View {
    // Binding Show Variable
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView, onEnd: @escaping ()->()) -> some View {
        //Using background so it automatically uses swiftui frame size inly
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)
            )
    }
}
