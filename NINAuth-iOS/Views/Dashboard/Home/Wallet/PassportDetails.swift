//
//  PassportConfirmationView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 20/05/2025.
//

import SwiftUI

struct PassportConfirmationView: View {
    @State private var agreeToSave = false
    @State private var showSuccessDialog = false
    @State private var navigateToWalletView = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .customFont(.title, fontSize: 20)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 10)

                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 2)
                        Image("Nigeria_passport")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                    }

                    Text("Passport Details Found")
                        .customFont(.title, fontSize: 20)
                        .multilineTextAlignment(.center)

                    Text("Your Nigerian Passport linked to your NIN was found successfully.")
                        .customFont(.body, fontSize: 16)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("The following information will be extracted")
                            .customFont(.headline, fontSize: 16)
                            .padding(.bottom, 8)

                        VStack(alignment: .leading, spacing: 25) {
                            ForEach([
                                 "Given Names", "Date of Birth",
                                "Gender", "Photograph", "Issue Date & Expiry"
                            ], id: \.self) { item in
                                HStack(spacing: 12) {
                                    Image("checks")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                    Text(item)
                                        .customFont(.body, fontSize: 14)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    HStack(alignment: .top, spacing: 12) {
                        Button(action: {
                            agreeToSave.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 24, height: 24)
                                    .background(agreeToSave ? Color.green.opacity(0.1) : Color.white)
                                if agreeToSave {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.button)
                                        .font(.system(size: 14, weight: .bold))
                                }
                            }
                        }

                        Text("I agree to save this information securely in your digital ID wallet.")
                            .customFont(.body, fontSize: 16)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 20)

                    Button(action: {
                        withAnimation {
                            showSuccessDialog = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            showSuccessDialog = false
                            navigateToWalletView = true
                        }
                    }) {
                        Text("Add to wallet")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(agreeToSave ? Color.button : Color.button.opacity(0.7))
                            .cornerRadius(4)
                    }
                    .disabled(!agreeToSave)
                    .padding(.bottom, 16)
                }
                .padding()
            }
            .background(Color.white)

            // ✅ Simplified Success Dialog
            if showSuccessDialog {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)

                    Text("Added!")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("ID Added Successfully to your Wallet.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: 250)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 8)
                .transition(.scale)
            }

            // ✅ Push-style Navigation
            NavigationLink(
                destination: WalletView()
                    .navigationBarBackButtonHidden(true),
                isActive: $navigateToWalletView
            ) {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
}

struct PassportConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        PassportConfirmationView()
    }
}
