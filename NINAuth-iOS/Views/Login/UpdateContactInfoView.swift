//
//  UpdateContactInfoView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/04/2025.
//


//
//  updateContact.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/04/2025.
//

import SwiftUI

struct UpdateContactInfoView: View {
    @State private var email: String = ""
    @State private var preferredContact: String = "SMS"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Header
            HStack {
                Button(action: {
                    // Handle back action
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("buttonColor"))
                        
                }
                
                Spacer()
                
                Button(action: {
                    // Handle skip action
                }) {
                    Text("Skip this step")
                        .foregroundColor(Color("buttonColor"))
                        .font(.system(size: 16, weight: .bold))
                }
            }
            
            Text("Update Your Contact Information")
                .font(.title2)
                .bold()
            
            Text("Providing your mobile number enables instant activation of SMS two-factor authentication (2FA) upon verification.")
                .foregroundColor(.black)
                .font(.subheadline)
            
            // Mobile Number Section
            VStack(alignment: .leading, spacing: 5) {
                Text("Mobile number")
                    .font(.headline)
                
                HStack {
                    Text("080 6622 8773") // Replace with dynamic data if needed
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("Trusted Number")
                        .foregroundColor(Color("buttonColor"))
                        .font(.caption)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            }
            
            // Link more numbers
            Button(action: {
                // Handle linking more numbers
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("buttonColor"))
                    
                    Text("You can link more mobile numbers")
                        .foregroundColor(Color("buttonColor"))
                        .bold()
                }
            }
            
            // Email Input Section
            VStack(alignment: .leading, spacing: 5) {
                Text("Email Address")
                    .font(.headline)
                
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
            }
            
            // Preferred Contact Mode
            VStack(alignment: .leading, spacing: 5) {
                Text("Preferred mode of contact")
                    .font(.headline)
                
                HStack {
                    RadioButton(title: "SMS", isSelected: preferredContact == "SMS") {
                        preferredContact = "SMS"
                    }
                    
                    RadioButton(title: "Email", isSelected: preferredContact == "Email") {
                        preferredContact = "Email"
                    }
                }
            }
            
            // Info Alert
            HStack(alignment: .top) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.orange)
                
                Text("Accurate contact details help us verify your identity and facilitate important communications and service delivery.")
                    .font(.footnote)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color(UIColor.systemYellow).opacity(0.2))
            .cornerRadius(10)
            
            // Continue Button
            Button(action: {
                // Handle continue action
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("buttonColor"))
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
}

// Custom Radio Button View
struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Circle()
                .stroke(isSelected ? Color.green : Color.gray, lineWidth: 2)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .fill(isSelected ? Color.green : Color.clear)
                        .frame(width: 10, height: 10)
                )
            
            Text(title)
                .foregroundColor(.black)
        }
        .onTapGesture {
            action()
        }
    }
}

struct UpdateContactInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateContactInfoView()
    }
}
