//
//  ConsentReviewView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct ConsentReviewView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appState: AppState
    @State var consentRequest: ConsentRequest
    @State var code: String
    @StateObject var viewModel = ConsentViewModel()
    @State private var isPressed = false

    var body: some View {
        bodyView
//        if #available(iOS 16.0, *) {
//            bodyView
//                .toolbarBackground(.bg, for: .navigationBar)
//                .toolbarRole(.editor)
//        }else {
//            bodyView
//        }
    }
    
    var bodyView: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Consent")
                            .customFont(.headline, fontSize: 24)
                        Text("send_your_data_to_this_organization".localized)
                            .customFont(.body, fontSize: 17)
                        
                        enterpriseData
                    }
                    .padding(.bottom, 20)

                    Text("before_you_proceed_please_review_the_information_you_are_sharing".localized)
                        .customFont(.body, fontSize: 17)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 30) {
                        if let data = consentRequest.consent?.data_requested {
                            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                                InformationCardView(number: index, title: item ?? "")
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.white)
                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                Spacer()

                HStack(spacing: 5) {
                    Button {
                        approveReview("rejected")
                    } label: {
                        Text("Reject")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.red)
                    .cornerRadius(4)

                    Button {
                        approveReview("approved")
                    } label: {
                        Text("Approve")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.button)
                    .cornerRadius(4)
//                    .halfSheet(showSheet: $viewModel.consentApprove) {
//                        approvedSheet
//                    } onEnd: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }

                }
            }
            .padding()
            .onAppear {
                appState.initialRequestCode = ""
            }
            
            if case .loading = viewModel.state {
                //TODO: Add your custom loding view here
                ProgressView()
                    .scaleEffect(2)
            }
            
            BottomSheetView(isPresented: $viewModel.consentRevoked) {
                rejectedSheet
                    .padding(.bottom, 50)
            }
            .onChange(of: viewModel.consentRevoked) { _ in
                if(viewModel.consentRevoked == false) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            
            BottomSheetView(isPresented: $viewModel.consentApprove) {
                approvedSheet
                    .padding(.bottom, 50)
            }
            .onChange(of: viewModel.consentApprove) { _ in
                if(viewModel.consentApprove == false) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            

            Spacer()
        }
    }
    
    var enterpriseData: some View {
        HStack {
            Image(uiImage: consentRequest.consent?.enterprise?.logo?.imageFromBase64 ?? UIImage())
                .resizable()
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 8) {
                Text(consentRequest.consent?.enterprise?.name ?? "")
                    .customFont(.headline, fontSize: 17)
                Text(consentRequest.consent?.reason ?? "")
                    .customFont(.subheadline, fontSize: 14)
            }

            Spacer()

            Image("organisation")
                .resizable()
                .frame(width: 21, height: 21)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white)
        .mask(
            RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    var rejectedSheet: some View {
        VStack(spacing: 10) {
            HStack {
                EmptyView()
                Spacer()
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .trailing)
                    .padding(.top, 30)
                    .onTapGesture {
                        viewModel.consentRevoked.toggle()
                    }
            }
            Image("checkmark_transparent")
            Text("this_organization_has_been_blocked_from_accessing_your_data")
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
    }

    var approvedSheet: some View {
        VStack(spacing: 10) {
            HStack {
                EmptyView()
                Spacer()
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .trailing)
                    .padding(.top, 30)
                    .onTapGesture {
                        viewModel.consentApprove.toggle()
                    }
            }
            Image("checkmark_transparent")
            Text("the_selected_data_has_been_shared")
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
    }

    func approveReview(_ status: String) {
        var review = ConsentCreate()
        review.requestCode = code
        review.status = status
        if status == "approved" {
            Task {
                await viewModel.approveConsent(consentCreated: review)
            }
        } else {
            Task {
                await viewModel.rejectConsent(consentCreated: review)
            }
        }
    }
}

#Preview {
    ConsentReviewView(consentRequest: ConsentRequest(), code: "")
        .environmentObject(AppState())
}
