//
//  ConsentView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct ConsentView: View {
    @State private var selected: ApprovalStatus = .approved

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

                ChosenStatusView(status: selected)
            }
        }
    }
}

#Preview {
    ConsentView()
}

enum ApprovalStatus: String, CaseIterable {
    case approved = "Approved Access"
    case rejected = "Rejected"
}

struct ChosenStatusView: View {
    var status: ApprovalStatus

    var body: some View {
        switch status {
        case .approved:
            ConsentApprovedView(status: true)
        case .rejected:
            ConsentApprovedView(status: false)
        }
    }
}
