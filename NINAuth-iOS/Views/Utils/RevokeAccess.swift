//
//  Revokeaccess.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 24/04/2025.
//
import SwiftUI

struct RevokeAccessBottomSheetView: View {
    @State private var isPresented = true
    @State private var selectedReason: String = ""
    let reasons = ["Privacy concern", "No longer using service", "Other"]

    var body: some View {
        ZStack {
            // Main background
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)

            // Trigger button (optional if you want to toggle)
            VStack {
                Button("Show Bottom Sheet") {
                    isPresented = true
                }
                Spacer()
            }

            // Bottom Sheet Overlay
            if isPresented {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }

                VStack(spacing: 20) {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(.top, 10)

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
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Menu {
                        ForEach(reasons, id: \.self) { reason in
                            Button(reason) {
                                selectedReason = reason
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
                        // Handle revoke logic
                        isPresented = false
                    }) {
                        Text("Revoke access")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }

                    Spacer(minLength: 10)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemBackground)))
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

#Preview {
    RevokeAccessBottomSheetView()
}
