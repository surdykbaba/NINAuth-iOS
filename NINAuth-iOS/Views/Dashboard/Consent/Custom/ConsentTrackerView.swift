//
//  ConsentTrackerView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct ConsentTrackerView: View {
    @State var sizeOfText: CGSize = CGSize(width: 0, height: 0)
    var title: String

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Circle()
                    .frame(width: 13, height: 13)
                    .foregroundColor(Color.button)
                RoundedRectangle(cornerRadius: 1)
                    .frame(width: 3, height: sizeOfText.height + 5)
                    .foregroundColor(Color.button.opacity(0.1))
            }
            Text(title)
                .customFont(.body, fontSize: 16)
                .fixedSize(horizontal: false, vertical: true)
                .background(GeometryReader { (geometryProxy : GeometryProxy) in
                    HStack {}
                    .onAppear {
                        sizeOfText = geometryProxy.size
                    }
                })
        }
    }
}

#Preview {
    ConsentTrackerView(title: "Account opening")
}
