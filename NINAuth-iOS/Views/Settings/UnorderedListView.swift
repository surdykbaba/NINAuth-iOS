//
//  UnorderedListView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct UnorderedListView: View {
    var listItem: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("•")
                .customFont(.title, fontSize: 15)
            Text(listItem)
        }
    }
}

#Preview {
    UnorderedListView(listItem: "Access your personal information")
}
