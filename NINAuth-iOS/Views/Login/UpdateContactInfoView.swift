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
    @State private var phone2 = ""
    @State private var showDialog = false
    @State private var showEmailDialog = false
    @State private var isPhoneValid: Bool = true
    @State private var isEmailValid: Bool = true
    @State private var isFormValid: Bool = true
    @State private var isOTPValid: Bool = true
    @State private var otp: String = ""
    @State private var errTitle = ""
    @State private var showSuccessMessage: Bool = false
    @State private var successMessageType: String = ""
    @State private var msg = ""
    @State private var showAlert = false
    @FocusState private var focusedField: Field?

    enum Field {
        case phone, otp, email
    }

    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                if showSuccessMessage {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(successMessageType == "phone" ? "Phone number updated successfully" : "Email address updated successfully")
                            .customFont(.body, fontSize: 16)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showSuccessMessage = false
                            }
                        }
                    }
                }

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
                                        .customFont(.subheadline, fontSize: 16)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                            
                            Text("Email Address")
                                .customFont(.subheadline, fontSize: 16)
                                .padding(.top, 16)
                            
                            HStack {
                                Text(email.isEmpty ? "Add your email" : email)
                                    .customFont(.body, fontSize: 16)
                                    .foregroundColor(email.isEmpty ? Color.gray.opacity(0.5) : .gray)
                                
                                Spacer()
                                
                                Button {
                                    showEmailDialog.toggle()
                                } label: {
                                    Text(email.isEmpty ? "Add email" : "Edit email")
                                        .foregroundColor(Color(.button))
                                        .customFont(.subheadline, fontSize: 16)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
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
                    // Info Alert
                    HStack(alignment: .center, spacing: 16) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                        
                        Text("Accurate contact details help us verify your identity and facilitate important communications and service delivery.")
                            .customFont(.body, fontSize: 14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color(UIColor.systemYellow).opacity(0.2))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                // Continue Button
                Button(action: {
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
                        HStack {
                            Text("Skip this step")
                                .customFont(.subheadline, fontSize: 18)
                                .foregroundStyle(Color.button)
                            
                            Image(.skip)
                        }
                        .padding(.trailing)
                    }
                    .isDetailLink(false)
                }
            }
            .onAppear {
                phone = user.first?.phone_number ?? ""
                
            }
            .alert(errTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(msg)
            }
            
            NavigationLink(destination: TabControllerView(), isActive: $viewModel.continueReg) {}.isDetailLink(false)
                .frame(width: 0, height: 0)
            
            // Phone number bottom sheet
            BottomSheetView(isPresented: $showDialog) {
                updateMobileNumber
            }
            .onChange(of: showDialog) { _ in
                if(!showDialog) {
                    timer.upstream.connect().cancel()
                    currentTimer = 60
                }
            }
            
            // Email bottom sheet
            BottomSheetView(isPresented: $showEmailDialog) {
                updateEmailAddress
            }
            
            BottomSheetView(isPresented: $viewModel.otpTriggered) {
                enterOTP
                    .onAppear{
                        showDialog = false
                        showEmailDialog = false
                    }
            }
            
            if(viewModel.otpValidated == true) {
                Color.clear.onAppear {
                    viewModel.otpTriggered = false
                    if successMessageType == "phone" {
                        phone = phone2
                    }
                    showSuccessMessage = true
                }
                .frame(width: 0, height: 0)
            }else {
                Color.clear.onAppear {
                    phone = user.first?.phone_number ?? ""
                    
                }
                .frame(width: 0, height: 0)
            }
            
            if case .loading = viewModel.state {
                ProgressView()
                    .scaleEffect(2)
            }
            
            if case .failed(let errorBag) = viewModel.state {
                Color.clear.onAppear() {
                    errTitle = errorBag.title
                    msg = errorBag.description
                    showAlert = true
                }
                .frame(width: 0, height: 0)
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
                    TextField("12345678910", text: $phone2)
                        .keyboardType(.numberPad)
                        .customTextField()
                        .focused($focusedField, equals: .phone)
                        .onChange(of: phone2) { newValue in
                            if newValue.count >= 11 {
                                focusedField = nil
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke()
                                .fill(isPhoneValid ? .gray : .red)
                        )

                    if !isPhoneValid {
                        Text("Mobile Number Invalid")
                            .customFont(.subheadline, fontSize: 14)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 18)
                .padding(.top, 20)

                Button {
                    if(phone2.count > 10) {
                        Task {
                            successMessageType = "phone"
                            let request = SendOTPRequest(receiverId: phone2, medium: .sms)
                            await viewModel.triggerOTP(sendOTPRequest: request)
                        }
                    }
                } label: {
                    if(phone2.count > 10) {
                        Text("Continue")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }else{
                        Text("Resend OTP 00:\(currentTimer)")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .cornerRadius(4)
                .background(Color.button)
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
    
    var updateEmailAddress: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .trailing)
                    .padding(.top, 0)
                    .onTapGesture {
                        showEmailDialog.toggle()
                    }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Update Email Address")
                    .customFont(.headline, fontSize: 24)
                Text("your_info_is_secure")
                    .customFont(.body, fontSize: 16)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)

                VStack(alignment: .leading) {
                    Text("Email address")
                        .customFont(.subheadline, fontSize: 16)
                    TextField("your@gmail.com", text: $email)
                        .keyboardType(.emailAddress)
                        .customTextField()
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .email)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke()
                                .fill(isEmailValid ? .gray : .red)
                        )

                    if !isEmailValid {
                        Text("Email must be valid")
                            .customFont(.subheadline, fontSize: 14)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 18)
                .padding(.top, 20)

                Button {
                    if isValidEmail(email) {
                        isEmailValid = true
                        Task {
                            successMessageType = "email"
                            let request = SendOTPRequest(receiverId: email, medium: .email)
                            await viewModel.triggerOTP(sendOTPRequest: request)
                        }
                    } else {
                        isEmailValid = false
                    }
                } label: {
                    Text("Continue")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .cornerRadius(4)
                .background(Color.button)
                .padding(.bottom, 30)
            }
        }
        .padding()
        .background(Color(.white))
    }
    
    var enterOTP: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .trailing)
                    .padding(.top, 0)
                    .onTapGesture {
                        viewModel.otpTriggered = false
                        timer.upstream.connect().cancel()
                        currentTimer = 60
                    }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(successMessageType == "phone" ? "Update Mobile Number" : "Update Email Address")
                    .customFont(.headline, fontSize: 24)
                Text("your_info_is_secure")
                    .customFont(.body, fontSize: 16)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)

                VStack(alignment: .leading) {
                    Text("Enter OTP")
                        .customFont(.subheadline, fontSize: 16)
                        .padding(.top, 16)
                    TextField("123456", text: $otp)
                    .keyboardType(.numberPad)
                    .customTextField()
                    .focused($focusedField, equals: .otp)
                    .onChange(of: otp) { newValue in
                        if newValue.count >= 6 {
                            focusedField = nil
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke()
                            .fill(isOTPValid ? .gray : .red)
                    )
                    
                    Text(successMessageType == "phone" ?
                        "Enter OTP sent to \(phone2)" :
                        "Enter OTP sent to \(email)")
                }
                .padding(.bottom, 18)
                .padding(.top, 20)

                Button {
                    if(otp.count > 3) {
                        Task {
                            await viewModel.validateOTP(validateOTP: ValidateOTP(otp: otp))
                        }
                    }
                } label: {
                    Text("Continue")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .cornerRadius(4)
                .background(Color.button)
                .padding(.bottom, 30)
            }
        }
        .padding()
        .background(Color(.white))
    }
    
    // Email validation function
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
