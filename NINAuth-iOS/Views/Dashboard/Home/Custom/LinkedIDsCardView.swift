//
//  LinkedIDsCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct LinkedIDsCardView: View {
    @State var linkedIDs: LinkedIDs
    
    var body: some View {
        VStack {
            HStack {
                Image("phone_color")
                    .resizable()
                    .frame(width: 47, height: 47)

                VStack(alignment: .leading) {
                    Text(linkedIDs.functional_id ?? "")
                        .customFont(.headline, fontSize: 17)
                    Text(linkedIDs.functional_id_name ?? "")
                        .customFont(.caption, fontSize: 15)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 10, height: 15)
                    .customFont(.headline, fontSize: 15)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .padding(.horizontal, 10)
            .background(Color.white)
            .mask(
                RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

#Preview {
    LinkedIDsCardView(linkedIDs: LinkedIDs())
}
