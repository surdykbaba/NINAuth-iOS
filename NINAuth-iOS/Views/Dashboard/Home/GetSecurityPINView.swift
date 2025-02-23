//
//  NINAuthCodeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI
import Combine

struct GetSecurityPINView: View {
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var currentTimer: Date = .now + 17
    private let pasteboard = UIPasteboard.general
    @StateObject var viewModel = PinViewModel()
    @State private var buttonText = "Copy PIN"
    private var randomNumber = 0

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("security_pin")
                    .padding(.bottom, 10)
                    .customFont(.headline, fontSize: 28)

                Text("enter_the_code_below_with_your_user_id_to_access_the_ninauth_qr_code".localized)
                    .customFont(.body, fontSize: 18)
                    .padding(.bottom, 50)
            }

            VStack(alignment: .center, spacing: 10) {
                Text(String(viewModel.randomNumber))
                    .customFont(.headline, fontSize: 40)
                    .onReceive(timer) { time in
                        Log.info("The time is now \(time)")
                    }
                Text("authentication_pin".localized)
                    .customFont(.caption2, fontSize: 14)

                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.green)
                    Text(currentTimer, style: .timer)
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
    }

    func copyToClipboard() {
        pasteboard.string = String(viewModel.randomNumber)
        self.buttonText = "Copied!"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.buttonText = "copy_pin".localized
        }
    }
}

#Preview {
    GetSecurityPINView()
}
