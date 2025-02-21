//
//  ConsentView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct ConsentView: View {
    @State private var selected: ApprovalStatus = .approved
    @StateObject var viewModel = ConsentViewModel()

    var consentsData = [
        Consent(id: "1", userId: "1", enterprise_id: "ENTB52D4B11BCDB", enterprise: Enterprise(id: "1", name: "Enterprise TBSL", logo: "uploads/cd8018f95755df474fb56edb84501142.png", website: "https://www.gtbank.com", client_id: ""), data_requested: [
            "firstname",
            "surname",
            "telephoneno",
            "email",
            "gender",
            "birthdate"
        ], medium: "Online Verification", reason: "For account upgrade", status: "approved", created_at: "2025-02-21T14:31:34Z", updated_at: "2025-02-21T14:31:34Z"),
        Consent(id: "2", userId: "1", enterprise_id: "ENTB52D4B11BCDB", enterprise: Enterprise(id: "1", name: "Wema Bank", logo: "gtb_icon", website: "", client_id: ""), data_requested: [], medium: "", reason: "Account opening", status: "rejected", created_at: "26, July, 2024", updated_at: ""),
        Consent(id: "3", userId: "1", enterprise_id: "1", enterprise: Enterprise(id: "1", name: "Providus Bank", logo: "gtb_icon", website: "", client_id: ""), data_requested: [], medium: "", reason: "Account opening", status: "approved", created_at: "26, July, 2024", updated_at: ""),
        Consent(id: "4", userId: "1", enterprise_id: "1", enterprise: Enterprise(id: "1", name: "Guaranty Trust Bank", logo: "gtb_icon", website: "", client_id: ""), data_requested: [], medium: "", reason: "Account opening", status: "rejected", created_at: "26, July, 2024", updated_at: "")
    ]

    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            VStack {
                Picker("", selection: $selected) {
                    ForEach(ApprovalStatus.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .frame(height: 60)
                .padding()
                .onAppear {
                    Task {
                        await viewModel.getAllConsents()
                    }
                }
                if let consents = viewModel.consent.consents {
                    if consents.isEmpty {
                        Text("No data")
                        Spacer()
                            .customFont(.headline, fontSize: 17)
                    } else {
                        ChosenStatusView(status: selected, consents: viewModel.consent.consents ?? [])
                    }
                }
                else {
                    Text("No data")
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ConsentView()
}

enum ApprovalStatus: String, CaseIterable {
    case approved = "approved_access"
    case rejected = "Rejected"
}

struct ChosenStatusView: View {
    var status: ApprovalStatus
    var consents: [Consent]

    var body: some View {
        switch status {
        case .approved:
            ConsentApprovedView(consents: consents.filter { $0.status == "approved" })
        case .rejected:
            ConsentApprovedView(consents: consents.filter { $0.status != "approved" })
        }
    }
}
