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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var currentTimer = 60
    @State private var buttonText = "Copy PIN"
    @State private var isCopied = false
    @StateObject var deviceVM = DeviceViewModel()

    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("security_pin")
                        .padding(.bottom, 10)
                        .customFont(.headline, fontSize: 24)
                    
                    Text("enter_the_code_below_with_your_user_id_to_access_the_ninauth_qr_code")
                        .customFont(.body, fontSize: 16)
                        .padding(.bottom, 50)
                }
                
                VStack(alignment: .center, spacing: 10) {
                    Text(deviceVM.shareCode)
                        .lineSpacing(20)
                        .customFont(.headline, fontSize: 40)
                    
                    Text("authentication_pin".localized)
                        .customFont(.body, fontSize: 14)
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.green)
                        Text("00:\(currentTimer)")
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.button.opacity(0.1)))
                }
                .padding(.horizontal, 60)
                .padding(.vertical, 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.grayBackground.opacity(0.1))
                    .shadow(color: Color.secondary, radius: 8, x: 0, y: 10))
                .onReceive(timer) { time in
                    if currentTimer > 0 {
                        currentTimer -= 1
                    }
                }
                
                Spacer()
                
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
            .task {
                await deviceVM.getShareCode()
            }
            
            if case .loading = deviceVM.state {
                ProgressView()
                    .scaleEffect(2)
            }
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
