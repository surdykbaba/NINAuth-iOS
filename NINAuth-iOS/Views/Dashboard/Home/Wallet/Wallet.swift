//
//  IDmodal.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 12/05/2025.
//

import SwiftUI

struct MyWalletView: View {
    @State private var showSelectID = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Wallet")
                    .customFont(.title, fontSize: 24)
                    .padding(.bottom, 7)
                    
                Text("Add_your_government_issued_IDs")
                    .customFont(.body, fontSize: 17)
                    .foregroundColor(.textBlackSec)
            }
            .padding(.horizontal)

            Spacer()

           
            VStack(spacing: 16) {
                Text("Your_wallet_is_empty")
                    .foregroundColor(.black)
                    .customFont(.subheadline, fontSize: 24)

                Image("purse")
                    .resizable()
                    .scaledToFit()
                    .offset(y: -30)
                   
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                
                
    Image("background")
        .resizable()
        .scaledToFill()
        .frame(height: 487)
            )
            .cornerRadius(24)
            .padding(.horizontal)
            

            Spacer()

            Button(action: {
                showSelectID = true
            }) {
                Text("Add_your_first_id")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.button)
                    .cornerRadius(4)
                    .customFont(.title, fontSize: 17)
            }
            .padding(.horizontal)
            NavigationLink(destination: WalletView(), isActive: $showSelectID) {
                EmptyView()
            }
            .hidden()
        }
        .padding(.top)
        
    }
}

#Preview {
    NavigationView {
        MyWalletView()
    }
}
