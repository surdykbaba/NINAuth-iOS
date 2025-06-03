//
//  Report.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/06/2025.
//

import SwiftUI


struct ReportPhoneNumberBottomSheet: View {
    @Binding var isPresented: Bool
    @State private var selectedReason = "No longer in use"
    @State private var message = ""
    
    let reasons = ["No longer in use", "Lost phone", "Stolen phone", "Wrong number", "Other"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .customFont(.headline,fontSize: 20)
                        .foregroundColor(.primary)
                        .padding(8)
                        
                }
            }

        
            VStack(spacing: 12) {
                Image("caution")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                
                Text("Report Phone Number")
                    .customFont(.headline,fontSize: 22)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)

           
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Select a reason")
                        .customFont(.body,fontSize: 16)
                    Text("*")
                        .foregroundColor(.red)
                }
                
                Menu {
                    ForEach(reasons, id: \.self) { reason in
                        Button(reason) {
                            selectedReason = reason
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedReason)
                            .foregroundColor(.text)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
            }

           
            VStack(alignment: .leading, spacing: 6) {
                Text("Drop a message")
                    .customFont(.body,fontSize: 16)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $message)
                        .frame(height: 80)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    
                    if message.isEmpty {
                        Text("Type message")
                            .customFont(.body,fontSize: 16)
                            .foregroundColor(.secondary)
                            .padding(.leading, 12)
                            .padding(.top, 14)
                    }
                }
            }

           
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = false
                }
            }) {
                Text("Submit Report")
                    .customFont(.title, fontSize: 18)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.button)
                    .cornerRadius(4)
            }

            Spacer(minLength: 10)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: 460)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}


