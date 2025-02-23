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
        if #available(iOS 16.0, *) {
            bodyView
                .toolbarBackground(.bg, for: .navigationBar)
                .toolbarRole(.editor)
        }else {
            bodyView
        }
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
                            .customFont(.caption, fontSize: 17)
                        
                        enterpriseData
                    }
                    .padding(.bottom, 20)

                    Text("before_you_proceed_please_review_the_information_you_are_sharing".localized)
                        .customFont(.caption, fontSize: 17)
                        .padding(.bottom, 10)

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
                        approveReview("revoked")
                    } label: {
                        Text("Reject")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.red)
                    .cornerRadius(4)
                    .halfSheet(showSheet: $viewModel.consentRevoked) {
                        rejectedSheet
                    } onEnd: {
                        self.presentationMode.wrappedValue.dismiss()
                    }

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
                    .halfSheet(showSheet: $viewModel.consentApprove) {
                        approvedSheet
                    } onEnd: {
                        self.presentationMode.wrappedValue.dismiss()
                    }

                }
            }
            .padding()
            
            if case .loading = viewModel.state {
                //TODO: Add your custom loding view here
                ProgressView()
                    .scaleEffect(2)
            }
            

            Spacer()
        }
    }
    
    var enterpriseData: some View {
        HStack {
            AsyncImage(url: URL(string: consentRequest.consent?.enterprise?.logo ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
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
        ZStack {
            Color.white
            VStack(spacing: 10) {
                Image("checkmark_transparent")
                Text("this_organization_has_been_blocked_from_accessing_your_data".localized)
                    .padding(.bottom, 20)
            }
        }
    }

    var approvedSheet: some View {
        ZStack {
            Color.white
            VStack(spacing: 10) {
                Image("checkmark_transparent")
                Text("the_selected_data_has_been_shared".localized)
                    .padding(.bottom, 20)
            }
        }
    }

    func approveReview(_ status: String) {
        var review = ConsentCreate()
        review.deviceId = appState.getDeviceID()
        review.requestCode = code
        review.status = status
        review.consent = consentRequest.consent?.data_requested ?? []
        review.medium = consentRequest.consent?.medium ?? ""
        if status == "approve" {
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
