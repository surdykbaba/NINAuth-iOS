//
//  CheckIdentityView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct CheckIdentityView: View {
    @State var code: String
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = AuthViewModel()
    @State private var identificationNumber = ""
    @State private var isFormValid: Bool = false
    @State private var isPresentingAlert: Bool = false
    @State private var error = ErrorBag()

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("enter_your_national_identification_number".localized)
                    .customFont(.headline, fontSize: 24)
                Text("your_information_is_secure_with_us_and_will_be_used_solely_for verification_purposes.".localized)
                    .customFont(.body, fontSize: 17)
                    .padding(.bottom, 30)

                VStack(alignment: .leading, spacing: 10) {
                    Text("national_identification_number".localized)
                        .customFont(.subheadline, fontSize: 16)
                    TextField("12345678910", text: $identificationNumber)
                        .keyboardType(.numberPad)
                        .customTextField()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke()
                            .fill(isFormValid ? .gray : .red)
                        )
                        .onAppear(perform: {
                            isFormValid = true
                        })
                        .onChange(of: identificationNumber) { _ in
                            if(identificationNumber.count > 11) {
                                identificationNumber = String(identificationNumber.prefix(11))
                            }
                            validateNIN()
                        }
                    if !isFormValid {
                        Text("nin_must_be_11_digits_long".localized)
                            .customFont(.subheadline, fontSize: 16)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 20)

                Button {
                    validateNIN()
                } label: {
                    Text("continue_verification".localized)
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(isFormValid ? Color.button : Color.button.opacity(0.2))
                .cornerRadius(4)
                .disabled(!isFormValid)

                Spacer()

                NavigationLink(destination: VerifyIdentityView(), isActive: $viewModel.continueReg) {}.isDetailLink(false)
            }
            .padding(.top, 20)
            .padding()
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .alert(error.description, isPresented: $isPresentingAlert) {
                Button("OK", role: .cancel) { }
            }

            if case .loading = viewModel.state {
                //TODO: Add your custom loding view here
                ProgressView()
                    .scaleEffect(2)
            }

            if case .failed(let errorBag) = viewModel.state {
                //TODO: Add your custom error view here
                Color.clear.onAppear() {
                    error = errorBag
                    isPresentingAlert = true
                }
                .frame(width: 0, height: 0)
            }

            Spacer()
        }
    }

    private func validateNIN() {
        isFormValid = !identificationNumber.isEmpty && identificationNumber.count == 11 && identificationNumber.allSatisfy { ("0"..."9").contains($0) }
        
        if(isFormValid) {
            var registerUserRequest = RegisterUserRequest()
            registerUserRequest.deviceId = appState.getDeviceID()
            registerUserRequest.requestCode = code
            registerUserRequest.ninId = identificationNumber
            registerUserRequest.deviceMetadata = DeviceMetadata()
            Task {
                await viewModel.registerUser(registerUserRequest: registerUserRequest)
            }
        }
    }
}

#Preview {
    CheckIdentityView(code: "bunchhhhhh")
        .environmentObject(AppState())
}
