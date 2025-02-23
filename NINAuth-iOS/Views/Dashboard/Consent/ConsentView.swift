//
//  ConsentView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI
import EasySkeleton

struct ConsentView: View {
    @State private var selected: ApprovalStatus = .approved
    @StateObject private var viewModel = ConsentViewModel()
    @State private var searchText = ""

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

                if case .loading = viewModel.state {
                    VStack(spacing: 8) {
                        Spacer().frame(height: 4)
                        DataLoaderView()
                            .frame(height: 120)
                        Spacer().frame(height: 6)
                        DataLoaderView()
                            .frame(height: 120)
                        Spacer().frame(height: 6)
                        DataLoaderView()
                            .frame(height: 120)
                        Spacer().frame(height: 6)
                    }
                    .padding(.horizontal, 16)
                    .setSkeleton(.constant(true))
                }else {
                    consentBody
                }
                
                Spacer()
            }
            .task {
                await viewModel.getAllConsents()
            }

        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Consent")
                    .customFont(.headline, fontSize: 24)
            }
        }
    }
    
    var consentBody: some View {
        VStack {
            HStack {
                TextField("Search organization", text: $searchText)
                    .customTextField()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke()
                        .fill(.gray)
                    )
                
                Button {
                    
                } label: {
                    Image(.consentCalendar)
                        .resizable()
                        .frame(width: 48, height: 48)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            
            if (viewModel.consent.consents?.isEmpty == true || viewModel.consent.consents == nil) {
                Group{
                    Image(.consentSearch)
                        .resizable()
                        .frame(width: 59, height: 54)
                    Text("No data to display")
                }
                .padding(.bottom, 100)
            }else {
                consentData
            }
        }
        .background(Color(.white))
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke()
            .fill(Color(.white))
        )
        .padding(.horizontal, 20)
    }
    
    var consentData: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 30) {
                ForEach(viewModel.consent.consents ?? [], id: \.self) { consent in
                    if(selected == .approved && consent.status == "approved") {
                        ConsentCardView(consent: consent)
                    }else if(selected == .rejected && consent.status != "approved") {
                        ConsentCardView(consent: consent)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .padding()
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
