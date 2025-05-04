//
//  DataSharingView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct DataSharingView: View {
    @State private var showAlert: Bool = false
    var dataSharingOptions = [
        DataSharingOptions(dataItem: "Full Name", color: Color.yellow),
        DataSharingOptions(dataItem: "Mobile Number", color: Color.green),
        DataSharingOptions(dataItem: "Date of Birth", color: Color.orange),
        DataSharingOptions(dataItem: "Place of Origin", color: Color.purple),
        DataSharingOptions(dataItem: "Gender", color: Color.yellow),
        DataSharingOptions(dataItem: "Photo", color: Color.green),
        DataSharingOptions(dataItem: "Registered Address", color: Color.orange)
        
    ]
    
    var body: some View {
        Color.secondaryGrayBackground
            .ignoresSafeArea()
            .overlay(
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("offline_data_sharing".localized)
                                .padding(.bottom, 10)
                                .padding(.top, 40)
                                .customFont(.headline, fontSize: 24)
                            
                            Text("manage_and_update_the_personal_information_you_share_with_organizations_offline_to_stay_fully_in_control_of_your_data.".localized)
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(Color.transparentGreenBackground)
                                .mask(
                                    RoundedRectangle(cornerRadius: 4, style: .continuous))
                                .padding(.bottom, 20)
                            Text("only_selected_data_will_be_shared".localized)
                                .customFont(.headline, fontSize: 17)
                            
                            VStack(spacing: 30) {
                                ForEach(dataSharingOptions, id: \.self) { data in
                                    SingleDataSharingView(dataItem: data.dataItem, color: data.color)
                                }
                            }
                            .padding(.vertical, 30)
                            .padding(.horizontal, 15)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .environment(\._lineHeightMultiple, 1.2)
                            .mask(
                                RoundedRectangle(cornerRadius: 10, style: .continuous))
                            
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        showAlert = true
                    } label: {
                        Text("save_update".localized)
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.button)
                    .cornerRadius(4)
                    .padding()
                    .alert("Data Saved", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
            )
    }
}

#Preview {
    DataSharingView()
}

struct DataSharingOptions: Hashable {
    var dataItem: String
    var color: Color
}
