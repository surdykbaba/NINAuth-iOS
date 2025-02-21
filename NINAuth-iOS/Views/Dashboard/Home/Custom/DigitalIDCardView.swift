//
//  DigitalIDCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 13/02/2025.
//

import SwiftUI

struct DigitalIDCardView: View {
    var image: String
    var surname: String
    var otherNames: String
    var dob: String
    var nationality: String
    var sex: String

    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("FEDERAL REPUBLIC OF NIGERIA")
                                .customFont(.largeTitle, fontSize: 16)
                                .foregroundColor(Color.button)
                            Text("National Identity Card")
                                .customFont(.largeTitle, fontSize: 12)
                        }
                        .padding(.bottom, 20)

                        VStack(alignment: .leading, spacing: 15) {
                            doubleTextView(title: "SURNAME", subtitle: surname)
                            doubleTextView(title: "GIVEN NAMES/PRENOMS", subtitle: otherNames)
                            HStack(spacing: 20) {
                                doubleTextView(title: "DATE OF BIRTH", subtitle: dob)
                                doubleTextView(title: "NATIONALITY", subtitle: nationality)
                                doubleTextView(title: "SEX", subtitle: sex)
                            }
                        }
                    }

                    Image(base64String: image)?
                        .resizable()
                        .frame(width: 115, height: 115)
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Image("digital_id_card_background")
                    .resizable()
            )
    }

    func doubleTextView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(.largeTitle, fontSize: 10)
                .foregroundColor(.brown)
            Text(subtitle)
                .customFont(.largeTitle, fontSize: 15)
        }
    }
}

#Preview {
    DigitalIDCardView(image: "", surname: "ABIOLA", otherNames: "YETUNDE", dob: "30 JAN 2006", nationality: "NGA", sex: "F")
}

extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
    }
}
