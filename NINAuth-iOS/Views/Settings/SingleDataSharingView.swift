//
//  SingleDataSharingView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct SingleDataSharingView: View {
    @State var isChecked: Bool = false
    var dataItem: String
    var color: Color
    
    var body: some View {
        HStack {
            Toggle(isOn: $isChecked) {
                Text(dataItem)
            }
            .toggleStyle(CheckboxToggleStyle())
            Spacer()
            Rectangle()
                .fill(color)
                .frame(width: 3, height: 20)
        }
    }
}

#Preview {
    SingleDataSharingView(dataItem: "Full Name", color: Color.orange)
}
