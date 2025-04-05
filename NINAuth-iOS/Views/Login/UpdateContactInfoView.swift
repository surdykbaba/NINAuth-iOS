//
//  UpdateContactInfoView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/04/2025.
//

import SwiftUI
import RealmSwift

struct UpdateContactInfoView: View {
    @StateObject private var viewModel = AuthViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var currentTimer = 60
    @State private var email: String = ""
    @State private var preferredContact: String = "SMS"
    @ObservedResults(User.self) var user
    @State private var phone = ""
    @State private var showDialog = false
    @State private var isPhoneValid: Bool = true
    @State private var isFormValid: Bool = true
    @State private var isOTPValid: Bool = true
    @State private var otp: String = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Update Your Contact Information")
                            .customFont(.title, fontSize: 24)
                        
                        Text("Providing your mobile number enables instant activation of SMS two-factor authentication (2FA) upon verification.")
                            .foregroundColor(.textBlackSec)
                            .customFont(.body, fontSize: 18)
                        
                        // Mobile Number Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Mobile number")
                                .customFont(.subheadline, fontSize: 16)
                            
                            HStack {
                                Text(phone)
                                    .customFont(.body, fontSize: 16)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button {
                                    showDialog.toggle()
                                } label: {
                                    Text("Edit number")
                                        .foregroundColor(Color(.button))
                                        .font(.caption)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                            
                            Text("Email Address")
                                .customFont(.subheadline, fontSize: 16)
                                .padding(.top, 16)
                            
                            TextField("Enter your email", text: $email)
                                .keyboardType(.emailAddress)
                                .customTextField()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke()
                                        .fill(isFormValid ? .gray : .red)
                                )
                        }
                        .padding(.vertical, 16)
                        
                        // Preferred Contact Mode
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Preferred mode of contact")
                                .customFont(.subheadline, fontSize: 16)
                            
                            HStack(spacing: 24) {
                                RadioButton(title: "SMS", isSelected: preferredContact == "SMS") {
                                    preferredContact = "SMS"
                                }
                                
                                RadioButton(title: "Email", isSelected: preferredContact == "Email") {
                                    preferredContact = "Email"
                                }
                            }
                        }
                        .padding(.top)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                // Info Alert
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    
                    Text("Accurate contact details help us verify your identity and facilitate important communications and service delivery.")
                        .customFont(.body, fontSize: 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    //Spacer()
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
            }
            .foregroundColor(Color(.text))
            .padding()
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        TabControllerView()
                    } label: {
                        Text("Skip this step")
                            .customFont(.subheadline, fontSize: 18)
                            .foregroundStyle(Color.button)
                            .padding(.trailing)
                    }
                    .isDetailLink(false)
                }
            }
            .onAppear {
                phone = user.first?.phone_number ?? ""
            }
            
            NavigationLink(destination: TabControllerView(), isActive: $viewModel.continueReg) {}.isDetailLink(false)
                .frame(width: 0, height: 0)
            
            BottomSheetView(isPresented: $showDialog) {
                updateMobileNumber
            }
            .onChange(of: showDialog) { _ in
                if(!showDialog) {
                    timer.upstream.connect().cancel()
                    currentTimer = 60
                }
            }
        }
    }
    
    var updateMobileNumber: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .trailing)
                    .padding(.top, 0)
                    .onTapGesture {
                        showDialog.toggle()
                        timer.upstream.connect().cancel()
                        currentTimer = 60
                    }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Update Mobile Number")
                    .customFont(.headline, fontSize: 24)
                Text("your_info_is_secure")
                    .customFont(.body, fontSize: 16)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)

                VStack(alignment: .leading) {
                    Text("Mobile number")
                        .customFont(.subheadline, fontSize: 16)
                    TextField("12345678910", text: $phone)
                        .keyboardType(.numberPad)
                        .customTextField()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke()
                            .fill(isPhoneValid ? .gray : .red)
                        )
                        
                    if !isPhoneValid {
                        Text("Mobile Number Invalid")
                            .customFont(.subheadline, fontSize: 14)
                            .foregroundColor(.red)
                    }
                    
                    Text("Enter OTP")
                        .customFont(.subheadline, fontSize: 16)
                        .padding(.top, 16)
                    TextField("123456", text: $otp)
                        .keyboardType(.numberPad)
                        .customTextField()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke()
                            .fill(isOTPValid ? .gray : .red)
                        )

                        
                    if !isOTPValid {
                        Text("OTP Invalid")
                            .customFont(.subheadline, fontSize: 14)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 18)
                .padding(.top, 20)

                Button {
                    if(isOTPValid) {
                        var ids = [UserkeyPair]()
                        if(!phone.isEmpty) {
                            ids.append(UserkeyPair(key: "Phone Number", value: phone))
                        }
                        if(!email.isEmpty) {
                            ids.append(UserkeyPair(key: "Email", value: email))
                        }
                        let userInfo = UpdateUserInfo(ids: ids, medium: preferredContact.lowercased())
                        Task {
                            await viewModel.updateInfo(updateUserInfo: userInfo)
                        }
                    }
                } label: {
                    Text("Resend OTP 00:\(currentTimer)")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .cornerRadius(4)
                .background(Color.button)
//                .disabled(!isValid)
                .padding(.bottom, 30)
            }
            .onReceive(timer) { time in
                if currentTimer > 0 {
                    currentTimer -= 1
                }
            }
        }
        .padding()
        .background(Color(.white))
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
