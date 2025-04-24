import SwiftUI
import UniformTypeIdentifiers

struct ConsentDetailsView: View {
    @State var consent: Consent
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = ConsentViewModel()
    @State private var showRevokeSheet = false
    @State private var isCopied = false
    @State private var showAlert: Bool = false
    @State private var error = ErrorBag()
    
    var body: some View {
        mainBody
    }
    
    var mainBody: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(consent.enterprise?.name ?? "")
                            .customFont(.headline, fontSize: 24)
                        Text("Shared via \(consent.medium ?? "")")
                            .customFont(.headline, fontSize: 16)
                        Text(consent.getDisplayDate())
                            .customFont(.body, fontSize: 16)
                    }
                    .padding(.bottom, 15)

                    HStack {
                        Button {
                            if(consent.status == "approved") {
                                showRevokeSheet = true
                            }
                        } label: {
                            Text("revoke_access")
                                .customFont(.title, fontSize: 18)
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.button)
                        .cornerRadius(4)
                        .background(consent.status == "approved" ? Color.button : Color.button.opacity(0.1))
                        .disabled(consent.status == "approved" ? false : true)

                        HStack {
                            Text(consent.request_id ?? "")
                            Image(systemName: "square.on.square")
                        }
                        .padding(10)
                        .background(Color.transparentGreenBackground)
                        .mask(
                            RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke()
                            .fill(.gray)
                        )
                        .onTapGesture {
                            UIPasteboard.general.setValue(consent.enterprise_id ?? "",
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
                    .padding(.bottom, 30)

                    consentData
                    
                    consentDetail
                    
                    if case .failed(let errorBag) = viewModel.state {
                        Color.clear.onAppear {
                            error = errorBag
                            showAlert.toggle()
                        }.frame(width: 0, height: 0)
                    }
                    
                    if viewModel.consentRevoked {
                        Color.clear.onAppear {
                            self.presentationMode.wrappedValue.dismiss()
                        }.frame(width: 0, height: 0)
                    }
                }
                .padding()
            }
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
            .alert(error.description, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
            // Bottom sheet overlay
            if showRevokeSheet {
                CustomBottomSheet(isPresented: $showRevokeSheet) {
                    RevokeAccessView(isPresented: $showRevokeSheet, onRevoke: {
                        Task {
                            await viewModel.updateContent(consentUpdate: ConsentUpdate(status: "revoked", consentId: consent.id))
                        }
                    })
                }
            }
        }
    }
    
    var consentData: some View {
        VStack(spacing: 12) {
            Image(uiImage: consent.enterprise?.logo?.imageFromBase64 ?? UIImage())
                .resizable()
                .frame(width: 72, height: 72)
                .padding(.bottom, 16)
            
            Text("Your data was shared with \(consent.enterprise?.name ?? "")")
                .customFont(.headline, fontSize: 17)
            HStack {
                Image(systemName: "square.on.square")
                    .foregroundColor(Color.button)
                if let url = URL(string: consent.enterprise?.website ?? "") {
                    Link(consent.enterprise?.website ?? "", destination: url)
                        .tint(Color.button)
                }
            }.onTapGesture {
                UIPasteboard.general.setValue(consent.enterprise?.website ?? "",
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
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
    
    var consentDetail: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Consent details")
                .foregroundColor(Color(.textGrey))
                .padding(.bottom, 8)
            ConsentTrackerView(title: consent.reason ?? "")
            ConsentTrackerView(title: consent.getRequestString())
            ConsentTrackerView(title: consent.getDisplayDate())
            ConsentTrackerView(title: "Consent given by you")
            HStack(alignment: .top, spacing: 16) {
                Circle()
                    .frame(width: 13, height: 13)
                    .foregroundColor(Color.button)
                Text("ID generated \(consent.id ?? "")")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white)
        .mask(
            RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

// Custom bottom sheet container
struct CustomBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            // Bottom sheet content
            VStack {
                Spacer()
                content
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemBackground)))
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

// Modified RevokeAccessView based on your RevokeAccessBottomSheetView
struct RevokeAccessView: View {
    @Binding var isPresented: Bool
    var onRevoke: () -> Void
    @State private var selectedReason: String = ""
    let reasons = ["Privacy concern", "No longer using service", "Other"]
    
    var body: some View {
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
                onRevoke()
                isPresented = false
            }) {
                Text("Revoke access")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .disabled(selectedReason.isEmpty)
            .opacity(selectedReason.isEmpty ? 0.6 : 1)
            
            Spacer(minLength: 10)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ConsentDetailsView(consent: Consent())
        .environmentObject(AppState())
}
