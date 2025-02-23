//
//  ConsentReviewView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI
import RealmSwift

struct ConsentReviewView: View {
    @EnvironmentObject var appState: AppState
    @State var consentRequest: ConsentRequest = ConsentRequest()
    @ObservedResults(Token.self) var token
    @StateObject var viewModel = ConsentViewModel()
    @State private var showRejectedSheet = false
    @State private var showApprovedSheet = false
    @State private var isPressed = false

    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Consent")
                        .customFont(.headline, fontSize: 24)
                    Text("send_your_data_to_this_organization".localized)
                        .customFont(.caption, fontSize: 17)
                }
                .padding(.bottom, 20)

                ConsentReviewOrganisationCard(icon: "nhis_icon", organisationName: consentRequest.enterprise?.name ?? "", reason: consentRequest.consent?.reason ?? "")
                    .padding(.bottom, 20)

                Text("before_you_proceed_please_review_the_information_you_are_sharing".localized)
                    .customFont(.caption, fontSize: 17)
                    .padding(.bottom, 10)

                VStack(alignment: .leading, spacing: 30) {
                    if let data = consentRequest.consent?.data_requested {
                        ForEach(data, id: \.self) { item in
                            InformationCardView(number: 0, title: item)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color.white)
                .mask(
                    RoundedRectangle(cornerRadius: 10, style: .continuous))

                Spacer()

                HStack(spacing: 5) {
                    Button {
                        approveReview("revoked")
                        showRejectedSheet.toggle()
                    } label: {
                        Text("Reject")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.red)
                    .cornerRadius(4)
                    .halfSheet(showSheet: $showRejectedSheet) {
                        rejectedSheet
                    } onEnd: {
                        print("dismissed")
                    }

                    Button {
                        approveReview("approved")
                        showApprovedSheet.toggle()
                    } label: {
                        Text("Approve")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.button)
                    .cornerRadius(4)
                    .halfSheet(showSheet: $showApprovedSheet) {
                        approvedSheet
                    } onEnd: {
                        print("dismissed")
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
                Button {} label: {
                    Text("view_organization".localized)
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.button)
                .cornerRadius(4)
            }
        }
    }

    func approveReview(_ status: String) {
        var review = ConsentCreate()
        review.deviceId = appState.getDeviceID()
        review.requestCode = token.first?.requestCode
        review.status = status
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

    func moveToScreen(consent: Consent) -> some View {
        NavigationLink(destination: OrganizationCardView(consent: consent), isActive: $viewModel.consentApprove){}
    }
}

#Preview {
    ConsentReviewView()
}
