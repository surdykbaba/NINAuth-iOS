//
//  ForgotPinView.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 26/02/2025.
//

import SwiftUI

struct ForgotPinView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = PinViewModel()
    @State private var identificationNumber = ""
    @State private var isFormValid: Bool = false
    @State private var isPresentingAlert: Bool = false
    @State private var error = ErrorBag()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Reset PIN")
                    .customFont(.headline, fontSize: 24)
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
                        }
                    if !isFormValid {
                        Text("nin_must_be_11_digits_long".localized)
                            .customFont(.subheadline, fontSize: 16)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 20)

                Button {
                    if(isFormValid) {
                        Task {
                            await viewModel.forgotPin(resetPinRequest: ResetPinRequest(deviceId: appState.getDeviceID(), nin: identificationNumber, deviceMetadata: DeviceMetadata()))
                        }
                    }
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

                NavigationLink(destination: VerifyIdentityView(), isActive: $viewModel.forgotPinSet) {}.isDetailLink(false)
            }
            .padding(.top, 20)
            .padding()
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $isPresentingAlert) {
                Button("OK", role: .cancel) { }
            }message: {
                Text(error.description)
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
        .onAppear {
            appState.fromForgotPin = true
        }
    }
}

#Preview {
    ForgotPinView()
        .environmentObject(AppState())
}
