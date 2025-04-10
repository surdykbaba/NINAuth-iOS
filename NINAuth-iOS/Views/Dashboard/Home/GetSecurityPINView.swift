//
//  NINAuthCodeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

struct GetSecurityPINView: View {
    //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var currentTimer = 60
    @State private var buttonText = "Copy Code"
    @State private var isCopied = false
    @StateObject var deviceVM = DeviceViewModel()
    @State private var errTitle = ""
    @State private var msg = ""
    @State private var showDialog: Bool = false

    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("Share Code")
                        .padding(.bottom, 10)
                        .customFont(.headline, fontSize: 24)
                    
                    Text("enter_the_code_below_with_your_user_id_to_access_the_ninauth_qr_code")
                        .customFont(.body, fontSize: 16)
                        .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .center, spacing: 10) {
                    Text(deviceVM.shareCode)
                        .lineSpacing(20)
                        .customFont(.headline, fontSize: 40)
                    
//                    Text("authentication_pin".localized)
//                        .customFont(.body, fontSize: 14)
                    
//                    HStack {
//                        Text("30 days left")
//                            .foregroundColor(.green)
//                        Image(systemName: "clock.fill")
//                            .foregroundColor(.green)
//                    }
//                    .padding(.vertical, 5)
//                    .padding(.horizontal, 10)
//                    .background(RoundedRectangle(cornerRadius: 4, style: .continuous)
//                        .fill(Color.button.opacity(0.1)))
                }
                .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
                .padding(.vertical)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.white)))
//                .onReceive(timer) { time in
//                    if currentTimer > 0 {
//                        currentTimer -= 1
//                    }
//                }
                VStack {
                    if (deviceVM.consents.isEmpty == true) {
                        VStack(spacing: 20) {
                            Text("USAGE HISTORY")
                                .foregroundColor(Color(.textGrey))
                                .customFont(.subheadline, fontSize: 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(.logEmpty)
                                .resizable()
                                .frame(width: 83, height: 83)
                            
                            Text("This code hasn't been used")
                                .customFont(.body, fontSize: 16)
                            
                            Text("Companies will appear here once they use this code to verify your NIN data")
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .customFont(.body, fontSize: 14)
                                .foregroundColor(Color(.textGrey))
                                .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }else {
                        consentData
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.white)))
                .alert(errTitle, isPresented: $showDialog) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(msg)
                }
                
                Spacer()
            }
            .padding()
            .overlay {
                if isCopied {
                    Text("Copied to clipboard")
                        .customFont(.subheadline, fontSize: 16)
                        .foregroundStyle(Color(.text))
                        .padding()
                        .background(Color(.white).cornerRadius(20))
                        .padding(.bottom)
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    copyToClipboard()
                } label: {
                    Text(buttonText)
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.button)
                .cornerRadius(4)
                .padding()
            }
            .task {
                await deviceVM.getShareCode()
                await deviceVM.getLogs()
            }
            
            if case .loading = deviceVM.state {
                ProgressView()
                    .scaleEffect(2)
            }
            
            if case .failed(let errorBag) = deviceVM.state {
                Color.clear.onAppear() {
                    errTitle = errorBag.title
                    msg = errorBag.description
                    showDialog = true
                }
                .frame(width: 0, height: 0)
            }
        }
        .background(Color(.bg))
    }
    
    var consentData: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 30) {
                ForEach(deviceVM.consents, id: \.self) { consent in
                    HStack {
                        HStack(spacing: 30) {
                            RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(Color.greenText)
                                .frame(width: 4, height: 80)

                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 10) {
                                    Text(consent.enterprise?.name ?? "")
                                        .customFont(.headline, fontSize: 17)
//                                    Image(systemName: "chevron.right")
                                }
                                Text(consent.reason ?? "")
                                    .customFont(.body, fontSize: 16)
                                Text(consent.getDisplayDate())
                                    .customFont(.subheadline, fontSize: 16)
                            }
                        }

                        Spacer()

                        Image(uiImage: consent.enterprise?.logo?.imageFromBase64 ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                    }
                    .frame(maxHeight: 84)
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .padding()
        }
    }

    func copyToClipboard() {
        UIPasteboard.general.setValue(deviceVM.shareCode,
                    forPasteboardType: UTType.plainText.identifier)
        withAnimation(.snappy) {
            isCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.snappy) {
                isCopied = false
            }
        }
    }
}

#Preview {
    GetSecurityPINView()
}
