//
//  LinkedIDsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct LinkedIDsView: View {
    @StateObject var viewModel = LinkedIDViewModel()

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
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("linked_ids")
                        .customFont(.headline, fontSize: 24)
                    
                    Text("view_other_functional_ids_linked_t_your_NIN")
                        .customFont(.body, fontSize: 16)
                        .padding(.bottom, 20)
                    
                    if (viewModel.linkedIds.isEmpty) {
                        Text("No linked IDs")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 100)
                    }else {
                        ForEach(viewModel.linkedIds, id: \.id) { ids in
                            LinkedIDsCardView(linkedIDs: ids)
                        }
                    }
                }
                .padding()
            }
            .task {
                await viewModel.getLinkedIDs()
            }
            
            if case .loading = viewModel.state {
                //TODO: Add your custom loding view here
                ProgressView()
                    .scaleEffect(2)
            }

            Spacer()
        }
    }
}

#Preview {
    LinkedIDsView()
}
