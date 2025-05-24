//
//  WalletFlow.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 17/05/2025.
//

import SwiftUI

struct PassportDetailsView: View {
    var selectedID: String? = nil
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToConfirmation = false
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .topLeading) {
                Image("eligible card")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 240)
                    .clipped()

                // Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("coat of arm icon")
                        .resizable()
                        .frame(width: 56)
                        .frame(height: 48)
                        .clipped()
                }
                .padding()
            }

            
            VStack(alignment: .leading, spacing: 20) {
               
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        
                        
                        Text("Nigerian Passport")
                            .customFont(.title, fontSize: 20)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                            
                    }
                    
                    Text("Your Nigerian passport is a secure ID for local and international services, not just travel.")
                        .customFont(.body, fontSize: 16)
                        .foregroundColor(.gray)
                        .padding(.bottom, 15)
                        .padding(.horizontal, 10)
                }
                
                
                
                VStack(alignment: .leading, spacing: 16) {
                    DetailPoint(
                        title: "Why Your Passport Matters",
                        description: "Your passport is key for travel, identification, and accessing important services."
                    )
                    
                    DetailPoint(
                        title: "Using Your Passport with NINAuth",
                        description: "Linking your passport on NINAuth makes verification faster and more secure."
                    )
                    
                    DetailPoint(
                        title: "What You Gain",
                        description: "Enjoy faster access, verified identity, and secure data protection."
                    )
                }
                
             Spacer(minLength: 2)
                NavigationLink(
                    destination: PassportConfirmationView(),
                    isActive: $navigateToConfirmation
                ) {
                    Button(action: {
                        guard !isLoading else { return }
                        
                        isLoading = true
                        
                        // Simulate loading for 10 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                            isLoading = false
                            navigateToConfirmation = true
                        }
                    }) {
                        HStack(spacing: 12) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.2)
                                Text("Checking Eligibility...")
                                    .customFont(.title, fontSize: 18)
                            } else {
                                Text("Check Eligibility")
                                    .customFont(.title, fontSize: 18)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(isLoading ? Color.button.opacity(0.7) : Color.button)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 0.2), value: isLoading)
                    }
                    .disabled(isLoading)
                }
            }
            .padding(20)
            .background(
                Color.white
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                    )
            )
            .offset(y: -20)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .background(Color(UIColor.systemBackground))
    }
}


struct DetailPoint: View {
    var title: String
    var description: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
                
                    Text("•")
                .customFont(.title, fontSize: 20)
                        .foregroundColor(.black)
                
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .customFont(.title, fontSize: 16)
                    
                
                Text(description)
                    .customFont(.body, fontSize: 14)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}



struct PassportDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PassportDetailsView(selectedID: "Nigerian Passport")
    }
}
