//
//  LinkedIDsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct LinkedIDsView: View {
    @StateObject var viewModel = LinkedIDViewModel()
    var linkedIds: [LinkedIDs] = []

    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("linked_ids".localized)
                            .customFont(.headline, fontSize: 24)
                        Text("view_other_functional_ids_linked_t_your_NIN".localized)
                            .customFont(.caption, fontSize: 17)
                            .padding(.bottom, 20)
                        ForEach(linkedIds, id: \.id) { ids in
                            LinkedIDsCardView(icon: "phone_color", title: ids.id ?? "", subtitle: ids.user_id ?? "")
                        }
                        .onAppear {
                            Task {
                                await viewModel.getLinkedIDs()
                            }
                        }
                    }
                }
                .padding()
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

// Temporary struct
struct LinkedIDData: Identifiable, Equatable {
    var id = UUID()
    var icon: String
    var title: String
    var subtitle: String
}
