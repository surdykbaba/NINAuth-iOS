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
                
                Text("Add your government issued IDs to NINAuthWallet")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)

            Spacer()

            // Card with image and message
            VStack(spacing: 16) {
                Text("Your wallet is empty. Start by adding your first ID")
                    .foregroundColor(.black)
                    .customFont(.headline, fontSize: 24)

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
                Text("Add your first ID")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.button)
                    .cornerRadius(4)
            }
            .padding(.horizontal)

            // NavigationLink placed outside of the NavigationView to prevent double back navigation
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
