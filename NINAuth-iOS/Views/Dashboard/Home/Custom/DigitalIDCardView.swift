//
//  DigitalIDCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 13/02/2025.
//

import SwiftUI
import RealmSwift

struct DigitalIDCardView: View {
    @ObservedResults(User.self) var user

    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("federal_republic_of_nigeria".localized)
                            .customFont(.title, fontSize: 14)
                            .foregroundColor(Color.button)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 108)
                        
                        Text("national_identity_card".localized)
                            .customFont(.title, fontSize: 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        doubleTextView(title: "SURNAME", subtitle: user.first?.last_name ?? "")
                            .padding(.trailing, 108)
                        
                        doubleTextView(title: "GIVEN NAMES/PRENOMS", subtitle: "\(user.first?.first_name ?? "") \(user.first?.middle_name ?? "")")
                            .padding(.trailing, 108)
                        
                        HStack(spacing: 20) {
                            doubleTextView(title: "DATE OF BIRTH", subtitle: user.first?.getDOB() ?? "")
                            doubleTextView(title: "NATIONALITY", subtitle: "NGA")
                            doubleTextView(title: "SEX", subtitle: user.first?.gender ?? "")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                        .resizable()
                        .frame(height: 130)
                        .frame(width: 100, height: 130, alignment: .topTrailing)
                        .clipped()
                }
                
                Spacer()
            }
            .padding()
            .frame(height: 242)
            .frame(maxWidth: .infinity, maxHeight: 242, alignment: .leading)
            .background(
                Image("digital_id_card_background")
                    .resizable()
            )
    }

    func doubleTextView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(.largeTitle, fontSize: 12)
                .foregroundColor(.brown)
                .padding(.top, 16)
            Text(subtitle)
                .customFont(.largeTitle, fontSize: 14)
        }
    }
}

#Preview {
    DigitalIDCardView()
}
