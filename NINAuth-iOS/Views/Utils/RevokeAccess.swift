//
//  RevokeAccess.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 24/04/2025.
//

import SwiftUI

struct RevokeAccessView: View {
    @State private var selectedReason: String = ""
    @Binding var showSheet: Bool
    var onRevokeAction: () -> Void
    
    let reasons = ["Privacy concern", "No longer using service", "Other"]

    var body: some View {
        VStack(spacing: 20) {
            // Header with X mark positioned to the right of the title area
            HStack {
                Spacer()
                Button(action: {
                    showSheet = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.red)

            Text("Revoke access to your data?")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text("This organization will no longer have access to your data")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            Menu {
                ForEach(reasons, id: \.self) { reason in
                    Button(action: {
                        selectedReason = reason
                    }) {
                        Text(reason)
                    }
                }
            } label: {
                HStack {
                    Text(selectedReason.isEmpty ? "Select a reason" : selectedReason)
                        .foregroundColor(selectedReason.isEmpty ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
            }

            Button(action: {
                onRevokeAction()
                showSheet = false
            }) {
                Text("Revoke access")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.button)
                    .cornerRadius(8)
            }
            .disabled(selectedReason.isEmpty)

            Spacer()
        }
        .padding()
        .background(Color.white) // Added white background
        // This ensures the background extends to the edges
        .edgesIgnoringSafeArea(.all)
    }
}

struct RevokeAccessView_Previews: PreviewProvider {
    static var previews: some View {
        RevokeAccessView(showSheet: .constant(true), onRevokeAction: {})
    }
}
