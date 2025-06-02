//
//  UpdateAddress.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 02/06/2025.
//

import SwiftUI

struct updateAddressView: View {
    @State private var showSelectID = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Address Information")
                    .customFont(.title, fontSize: 24)
                    .padding(.bottom, 7)
                    .foregroundColor(.black)


                Text("Link your address to your NIN")
                    .customFont(.body, fontSize: 17)
                    .foregroundColor(.text)
            }
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 8) {
                       Text("10B Adeola Odeku Street, Apartment 3C, Victoria Island, Lagos State")
                            .customFont(.body, fontSize: 16)
                           .foregroundColor(.black)
                           

                       Text("Address from NIMC")
                        .customFont(.body, fontSize: 16)
                           .foregroundColor(.gray)

                       Spacer().frame(height: 8)

                       Text("Report Address")
                            .customFont(.body, fontSize: 16)
                           .foregroundColor(.red)
                
                           
                   }
                   .padding()
                   .background(Color(UIColor.systemGray6))
                   .cornerRadius(12)
                   .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                   .padding(.horizontal)
            Spacer()

            Button(action: {
                showSelectID = true
            }) {
                Text("Update Address")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.button)
                    .cornerRadius(4)
                    .customFont(.title, fontSize: 17)
            }
            .padding(.horizontal)
            NavigationLink(destination:  UpdateAddressView(), isActive: $showSelectID) {
                EmptyView()
            }
            .hidden()
        }
        .padding(.top)

    }
}

#Preview {
    NavigationView {
        updateAddressView()
    }
}
