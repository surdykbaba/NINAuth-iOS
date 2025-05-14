//
//  Document.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 14/05/2025.
//

import SwiftUI

struct WalletScreen: View {
    var body: some View {
        VStack(spacing: 16) {
           
            ZStack(alignment: .bottomLeading) {
                
                        Image("International passport")
                            .resizable()
                            .scaledToFit()
                            .padding(30)
               
            }
            .padding(.horizontal)

            HStack(spacing: 8) {
                Text("Nigerian Passport added to wallet")
                    .foregroundColor(.black)
                Image("checkmark.circle.fill")
                    .foregroundColor(.green)
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("More Actions")
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                .padding(.horizontal)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add new ID")
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal)
                }

                Button(action: {}) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete ID")
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)

            Button(action: {}) {
                Text("View ID")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

struct WalletScreen_Previews: PreviewProvider {
    static var previews: some View {
        WalletScreen()
    }
}
