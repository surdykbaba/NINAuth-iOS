//
//  AddPhonenumber.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/06/2025.
//
import SwiftUI

struct AddPhoneNumberBottomSheet: View {
    @Binding var isPresented: Bool
    @State private var phoneNumber: String = ""
    @State private var showOTPField = false
    @State private var otpCode: String = ""
    @State private var timeRemaining = 30
    @State private var timer: Timer?

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
           
            HStack {
                Text("Add Phone Number")
                    .customFont(.headline,fontSize: 22)
                    

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .customFont(.headline,fontSize: 20)
                        .foregroundColor(.primary)
                }
            }

            
            VStack(alignment: .leading, spacing: 8) {
                Text("Phone Number")
                    .customFont(.body,fontSize: 16)

                TextField("E.g 08123456789", text: $phoneNumber)
                    .padding()
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                    .keyboardType(.phonePad)
            }

            
            if showOTPField {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter OTP")
                        .customFont(.body,fontSize: 16)

                    TextField("123456", text: $otpCode)
                        .padding()
                        .frame(height: 50) 
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                        .keyboardType(.numberPad)

                    Text("Expires in \(timeRemaining) sec")
                        .customFont(.body,fontSize: 16)
                        .foregroundColor(.red)
                }
            }

            Spacer()
            Button(action: {
                if showOTPField {
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                } else {
                    
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showOTPField = true
                    }
                    startTimer()
                }
            }) {
                Text(showOTPField ? "Save Update" : "Continue")
                    .customFont(.title, fontSize: 18)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.button)
                    .cornerRadius(4)
            }
            .disabled(phoneNumber.isEmpty || (showOTPField && otpCode.isEmpty))
            .opacity((phoneNumber.isEmpty || (showOTPField && otpCode.isEmpty)) ? 0.6 : 1.0)

            Spacer(minLength: 10)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: showOTPField ? 460 : 400)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .onDisappear {
            timer?.invalidate()
                
        }
        
    }

    private func startTimer() {
        timeRemaining = 30
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}


