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
    var firstName: String
    var middleName: String
    var dob: String
    var nationality: String
    var issueDate: String
    var expiryDate: String
    var sex: String
    var height: Double
    var documentNo: Int

    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("FEDERAL REPUBLIC OF NIGERIA")
                                .customFont(.title, fontSize: 16)
                                .foregroundColor(Color.button)
                            Text("National Identity Card")
                                .customFont(.title, fontSize: 12)
                        }

                        HStack(alignment: .center) {
                            Image(systemName: "chevron.left")
                                .frame(width: 24, height: 30)
                                .customFont(.title, fontSize: 24)

                            Spacer()

                            VStack(alignment: .leading, spacing: 5) {
                                doubleTextView(title: "SURNAME", subtitle: "ABIOLA")
                                doubleTextView(title: "FIRST NAME", subtitle: "YETUNDE")
                                doubleTextView(title: "MIDDLE NAME", subtitle: "CHIBUIKE")

                                HStack(spacing: 20) {
                                    VStack(alignment: .leading) {
                                        doubleTextView(title: "DATE OF BIRTH", subtitle: "30 JAN 2006")
                                        doubleTextView(title: "NATIONALITY", subtitle: "NGA")
                                    }

                                    VStack(alignment: .leading) {
                                        doubleTextView(title: "ISSUE DATE", subtitle: "16 MAY 2019")
                                        HStack(spacing: 20) {
                                            doubleTextView(title: "SEX", subtitle: "F")
                                            doubleTextView(title: "HEIGHT", subtitle: "1.76M")
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Image("")
                        .resizable()
                        .frame(width: 70, height: 110)
                        .cornerRadius(10)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.green))
                }

                HStack(alignment: .bottom) {
                    Image("")
                        .resizable()
                        .frame(width: 50, height: 70)
                        .cornerRadius(10)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.green))

                    Spacer()

                    HStack(spacing: 50) {
                        doubleTextView(title: "EXPIRY", subtitle: "05/29")
                        doubleTextView(title: "DOCUMENT No", subtitle: "000000000000")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .padding()
        }
    }

    func doubleTextView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(.subheadline, fontSize: 10)
                .foregroundColor(.brown)
            Text(subtitle)
                .customFont(.headline, fontSize: 15)
        }
    }
}

#Preview {
    DigitalIDCardView(image: "", surname: "ABIOLA", firstName: "YETUNDE", middleName: "CHIBUILE", dob: "30 JAN 2006", nationality: "NGA", issueDate: "16 MAY 2019", expiryDate: "05/29", sex: "F", height: 1.76, documentNo: 000000000000)
}
