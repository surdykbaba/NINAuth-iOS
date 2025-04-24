//
//  ConsentDetailsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ConsentDetailsView: View {
    @State var consent: Consent
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = ConsentViewModel()
    @State private var showSheet = false
    @State private var isCopied = false
    @State private var showAlert: Bool = false
    @State private var error = ErrorBag()
    
    var body: some View {
        mainBody
//        if #available(iOS 16.0, *) {
//            mainBody
//                .toolbarBackground(.bg, for: .navigationBar)
//                .toolbarRole(.editor)
//        }else {
//            mainBody
//        }
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
                                showSheet = true
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
                        .halfSheet(showSheet: $showSheet) {
                            RevokeAccessView(showSheet: $showSheet, onRevokeAction: {
                                Task {
                                    await viewModel.updateContent(consentUpdate: ConsentUpdate(status: "revoked", consentId: consent.id))
                                }
                            })
                        } onEnd: {
                            Log.info("Dismissed Sheet")
                        }

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

#Preview {
    ConsentDetailsView(consent: Consent())
        .environmentObject(AppState())
}
