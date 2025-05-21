//
//  PassportDetails.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 20/05/2025.
//
import SwiftUI

struct PassportConfirmationView: View {
    @State private var agreeToSave = false
    @State private var navigateToPassportView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
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
                        .foregroundColor(.green)
                }
                .padding(.bottom, 5)

                Text("Nigerian Passport Details Found")
                    .customFont(.title, fontSize: 20)
                    .multilineTextAlignment(.center)

                Text("Your Nigerian Passport, linked to your NIN, has been successfully retrieved.")
                    .customFont(.body, fontSize: 16)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)

                
                VStack(alignment: .leading, spacing: 16) {
                    Text("The following information will be extracted")
                        .customFont(.title, fontSize: 16)
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 25) {
                        ForEach(["Surname", "Given Names", "Date of Birth", "Sex", "ID Photo", "Date of Issue", "Date of Expiry"], id: \.self) { item in
                            HStack(spacing: 12) {
                                Image("checks")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .alignmentGuide(.leading) { _ in 0 }
                                Text(item)
                                    .customFont(.body, fontSize: 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)

               
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

                
                NavigationLink(destination: PassportView()) {
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
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

struct PassportConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        PassportConfirmationView()
    }
}
