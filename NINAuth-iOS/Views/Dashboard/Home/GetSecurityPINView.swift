import SwiftUI
import Combine
import UniformTypeIdentifiers

struct GetSecurityPINView: View {
    @State private var currentTimer = 60
    @State private var buttonText = "Copy Code"
    @State private var isCopied = false
    @StateObject var deviceVM = DeviceViewModel()
    @State private var errTitle = ""
    @State private var msg = ""
    @State private var showDialog: Bool = false
    @State private var showResetSheet = false  // <- NEW

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
                    HStack(spacing: 8) {
                        Text(deviceVM.shareCode)
                            .lineSpacing(20)
                            .customFont(.headline, fontSize: 40)

                        Button(action: {
                            copyToClipboard()
                        }) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor((Color.button))
                        }
                    }

                    Text("Your secure code expire in 29 days")
                        .customFont(.title, fontSize: 14)
                        .foregroundColor((Color.button))

                        .padding(.top, 4)

                    Button(action: {
                        showResetSheet = true
                    }) {
                        Text("Reset")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.button)
                            .cornerRadius(4)
                            .frame(height: 32)
                            .frame(width: 106)
                    }
                }
                .frame(height: 150)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                )

                Spacer()

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
                    } else {
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
            }
            .padding()
//            .overlay {
//                if isCopied {
//                    Text("Copied to clipboard")
//                        .customFont(.subheadline, fontSize: 16)
//                        .foregroundStyle(Color(.text))
//                        .padding()
//                        .background(Color(.white).cornerRadius(20))
//                        .padding(.bottom)
//                        .shadow(radius: 5)
//                        .transition(.move(edge: .bottom))
//                        .frame(maxHeight: .infinity, alignment: .bottom)
//                }
//            }
//            .safeAreaInset(edge: .bottom) {
//                Button {
//                    copyToClipboard()
//                } label: {
//                    Text(buttonText)
//                        .customFont(.title, fontSize: 18)
//                        .foregroundStyle(.white)
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 18)
//                .background(Color.button)
//                .cornerRadius(4)
//                .padding()
//            }
            .task {
                await deviceVM.getShareCode()
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
        .sheet(isPresented: $showResetSheet) {
            if #available(iOS 16.0, *) {
                ResetShareCodeView(
                    onConfirm: {
                        showResetSheet = false
                        // TODO: Reset logic here
                    },
                    onCancel: {
                        showResetSheet = false
                    }
                )
                .presentationDetents([.height(290)])
                .presentationDragIndicator(.visible)
            } else {
                ResetShareCodeView(
                    onConfirm: {
                        showResetSheet = false
                        // TODO: Reset logic here
                    },
                    onCancel: {
                        showResetSheet = false
                    }
                )
            }
        }
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
