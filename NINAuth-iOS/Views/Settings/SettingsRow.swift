//
//  SettingsRow.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 29/01/2025.
//

import SwiftUI

struct SettingsRow: View {
    var image: String
    var name: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(image)
                .resizable()
                .frame(width: 25, height: 25)
                .padding(15)
                .background(Color("grayBackground"))
                .clipShape(Circle())
            Text(name)
                .customFont(.headline, fontSize: 19)
            
            Spacer()
            
            Image(systemName: "chevron.forward")
        }
    }
}


#Preview {
    SettingsRow(image: "lock", name: "Privacy policy")
}
