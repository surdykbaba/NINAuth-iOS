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
