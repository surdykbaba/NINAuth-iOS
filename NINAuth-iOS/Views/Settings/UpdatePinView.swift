//
//  UpdatePinView.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 26/02/2025.
//

import SwiftUI

struct UpdatePinView: View {
    @State var oldPIN: String = ""
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = PinViewModel()
    @State private var newPIN: String = ""
    @FocusState private var isFocused: Bool
    @State private var isValid: Bool = true
    private let numberOfFields = 6
    @State private var showAlert: Bool = false
    @State private var error = ErrorBag()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Set a new PIN".localized)
                    .customFont(.subheadline, fontSize: 24)
                    .padding(.bottom, 5)

                Text("set_a_6-digit_pin_for_your_ninauth_account.".localized)
                    .customFont(.body, fontSize: 18)
                    .padding(.bottom, 30)

                OTPView(numberOfFields: numberOfFields, otp: $newPIN, valid: $isValid)
                    .padding(.bottom, 20)
                    .onChange(of: newPIN) { newOtp in
                        if newOtp.count == numberOfFields && !newOtp.isEmpty {
                            isValid = true
                        }
                    } .focused($isFocused)
                    .background(Color(.white))
                    .frame(height: 56)
                    .foregroundColor(Color(.black))

                Button {
                    if(isValid) {
                        Task {
                            await viewModel.updatePin(updatePinRequest: UpdatePinRequest(deviceId: appState.getDeviceID(), oldPin: oldPIN, newPin: newPIN))
                        }
                    }
                } label: {
                    Text("continue".localized)
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(isValid ? Color.button : Color.button.opacity(0.2))
                .cornerRadius(4)
                .disabled(!isValid)
                .padding(.top, 48)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .alert(error.description, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }

            if case .loading = viewModel.state {
                //TODO: Add your custom loding view here
                ProgressView()
                    .scaleEffect(2)
            }
            
            if case .failed(let errorBag) = viewModel.state {
                Color.clear.onAppear {
                    error = errorBag
                    showAlert.toggle()
                }.frame(width: 0, height: 0)
            }
            
            if viewModel.pinUpdated == true {
                Color.clear.onAppear {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .frame(width: 0, height: 0)
            }

            Spacer()
        }
        .background(Color(.bg))
    }
}

#Preview {
    UpdatePinView()
        .environmentObject(AppState())
}
