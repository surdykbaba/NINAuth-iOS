//
//  HomeView.swift
//  NINAuth-iOS
//

//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = ConsentViewModel()
    @State private var selected: PickerOptions = .digitalID
    @ObservedResults(User.self) var user
    @ObservedResults(Token.self) var token

    @State private var showWallet = false
    
    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            VStack {
//                Picker("", selection: $selected) {
//                    ForEach(PickerOptions.allCases, id: \.self) {
//                        Text($0.rawValue)
//                    }
//                }
//                .pickerStyle(.segmented)
//                .frame(height: 60)
//                .padding()
//
//                ChosenPickerView(option: selected)
                DigitalIDView()
            }
            
            NavigationLink(destination: ConsentReviewView(consentRequest: viewModel.consentRequest, code: token.first?.requestCode ?? ""), isActive: $viewModel.isVerified) {}.isDetailLink(false)
            
            NavigationLink(destination: WalletView(), isActive: $showWallet) {}.isDetailLink(false)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading, ) {
                Text("Home")
                    .customFont(.headline, fontSize: 24)
                    .padding(.leading)
                
            }
        }
        .toolbar {
            // Trailing My Wallet Button
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showWallet = true
                }) {
                    HStack(spacing: 4) {
                        Text("My Wallet")
                            .customFont(.headline, fontSize: 17)
                            .foregroundColor(.button)
                        
                        Image("wallet icon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .foregroundColor(.button)
                    }
                    .padding(.leading)
                    .offset(x: -14)
                }
            }
        }
        .task {
            if(!appState.initialRequestCode.isEmpty) {
                var consentCode = ConsentCode()
                consentCode.deviceId = appState.getDeviceID()
                consentCode.requestCode = appState.initialRequestCode
                Task {
                    await viewModel.verifyConsent(consentCode: consentCode)
                }
            }
        }
    }
}

enum PickerOptions: String, CaseIterable {
    case digitalID = "My Digital ID"
    case scanQR = "Scan QR"
}

struct ChosenPickerView: View {
    var option: PickerOptions

    var body: some View {
        switch option {
        case .digitalID:
            DigitalIDView()
        case .scanQR:
            ScanQRCodeView()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
