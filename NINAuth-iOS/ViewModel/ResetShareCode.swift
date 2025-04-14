//
//  ResetShareCodeView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 14/04/2025.
//
import SwiftUI

struct ResetShareCodeView: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Cancel icon in top-right
            HStack {
                Spacer()
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding(10)
                        .contentShape(Rectangle())
                        .padding(.top, 20)
                }
            }

            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange)
                .padding(.top, -10)
            
            Text("Reset Code?")
                .customFont(.title, fontSize: 20)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            Text("Resetting the code will revoke access for all enterprises currently using it. Do you want to continue?")
                .customFont(.body, fontSize: 17)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }

                Button(action: onConfirm) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.button)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
#Preview {
    ResetShareCodeView(
        onConfirm: { print("Confirmed") },
        onCancel: { print("Cancelled") }
    )
}
