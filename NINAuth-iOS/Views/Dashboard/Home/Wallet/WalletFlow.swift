//
//  WalletFlow.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 17/05/2025.
//

import SwiftUI

struct NINAuthFlow: View {
    @State private var showBottomSheet = false
    @State private var navigateToPassportDetails = false
    @State private var selectedID: String? = nil
    
    var body: some View {
        NavigationView {
            WalletIDView(
                showBottomSheet: $showBottomSheet,
                navigateToPassportDetails: $navigateToPassportDetails,
                selectedID: $selectedID
            )
            .sheet(isPresented: $showBottomSheet) {
                SelectServiceView(
                    showBottomSheet: $showBottomSheet,
                    navigateToPassportDetails: $navigateToPassportDetails
                )
                // Use height parameter to show bottom sheet without full screen
                .frame(height: UIScreen.main.bounds.height * 0.85)
                .background(Color.white)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
}

struct SelectServiceView: View {
    @Binding var showBottomSheet: Bool
    @Binding var navigateToPassportDetails: Bool
    
    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Spacer()
                Button(action: {
                    showBottomSheet = false
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            
            Text("Select a service")
                .customFont(.headline, fontSize: 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            
            // Service List
            ScrollView {
                VStack(spacing: 0) {
                    // Digital Government Services
                    ServiceRow(
                        icon: "government modal",
                       
                        title: "Digital Government Services",
                        description: "Store your digital IDs for easy access to government services."
                    )
                    .onTapGesture {
                        showBottomSheet = false
                        navigateToPassportDetails = true
                    }
                    
                    Divider()
                    
                    // Driving and Transport
                    ServiceRow(
                        icon: "Driving modal",
                        
                        title: "Driving and Transport",
                        description: "Keep your transport cards ready for quick use."
                    )
                    .onTapGesture {
                        showBottomSheet = false
                        navigateToPassportDetails = true
                    }
                    
                    Divider()
                    
                    // Tax, Insurance and Benefits
                    ServiceRow(
                        icon: "Tax modal",
                        
                        title: "Tax, Insurance and Benefits",
                        description: "Manage your tax IDs, insurance info, and benefit cards."
                    )
                    .onTapGesture {
                        showBottomSheet = false
                        navigateToPassportDetails = true
                    }
                    
                    Divider()
                    
                    // Financial Services
                    ServiceRow(
                        icon: "financial modal",
                        
                        title: "Financial Services",
                        description: "Add your financial credentials to ease banking and loan verifications."
                    )
                    .onTapGesture {
                        showBottomSheet = false
                        navigateToPassportDetails = true
                    }
                    
                    Divider()
                    
                    // Memberships
                    ServiceRow(
                        icon: "Membership Modal",
                        
                        title: "Memberships",
                        description: "Add for easy access to social and professional programs"
                    )
                    .onTapGesture {
                        showBottomSheet = false
                        navigateToPassportDetails = true
                    }
                }
            }
        }
        .padding([.horizontal, .bottom])
        .background(Color.white)
    }
}

struct ServiceRow: View {
    let icon: String
    
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(7)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .customFont(.headline, fontSize: 17)
                
                Text(description)
                    .customFont(.body, fontSize: 15)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 16)
    }
}


struct NINAuthFlow_Previews: PreviewProvider {
    static var previews: some View {
        NINAuthFlow()
    }
}

struct SelectServiceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectServiceView(
            showBottomSheet: .constant(true),
            navigateToPassportDetails: .constant(false)
        )
    }
}
