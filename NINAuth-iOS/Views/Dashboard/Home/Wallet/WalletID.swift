//
//  WalletID.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 20/05/2025.
//
import SwiftUI

struct WalletIDView: View {
    @Binding var showBottomSheet: Bool
    @Binding var navigateToPassportDetails: Bool
    @Binding var selectedID: String?
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select an ID")
                .customFont(.title, fontSize: 24)
            
            Text("Select an ID to add to your wallet")
                .customFont(.subheadline, fontSize: 17)
            
           
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search ID", text: $searchText)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.05), radius: 2)
                
                Button(action: {
                    showBottomSheet.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.05), radius: 2)
                }
            }
            
           
            ScrollView {
                VStack(spacing: 16) {
                    IDCard(
                        icon: "Nigeria_passport",
                        title: "Nigerian Passport",
                        subtitle: "Nigeria Immigration Services",
                        isSelected: selectedID == "Nigerian Passport"
                    )
                    .onTapGesture {
                        selectedID = "Nigerian Passport"
                    }
                    
                    IDCard(
                        icon: "Voters_card",
                        title: "Voter's Card",
                        subtitle: "Independent National Electoral\nCommission",
                        isSelected: selectedID == "Voter's Card"
                    )
                    .onTapGesture {
                        selectedID = "Voter's Card"
                    }
                    
                    IDCard(
                        icon: "driving",
                        title: "Driver's License",
                        subtitle: "Federal Road Safety Corps",
                        isSelected: selectedID == "Driver's License"
                    )
                    .onTapGesture {
                        selectedID = "Driver's License"
                    }
                    
                    IDCard(
                        icon: "Lagos",
                        title: "Lagos State Residence Permit",
                        subtitle: "Lagos State Resident Registration\nAgency",
                        isSelected: selectedID == "Lagos State Residence Permit"
                    )
                    .onTapGesture {
                        selectedID = "Lagos State Residence Permit"
                    }
                    
                    
                    Spacer().frame(height: 20)
                    
                    
                    NavigationLink(
                        destination: PassportDetailsView(selectedID: selectedID ?? ""),
                        isActive: $navigateToPassportDetails
                    ) {
                        Text("Continue")
                            .customFont(.title, fontSize: 18)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.button)
                            .cornerRadius(4)
                    }
                    .disabled(selectedID == nil)
                    
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .navigationBarHidden(true)
        
    }
}

struct IDCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 67, height: 66)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .customFont(.title, fontSize: 17)
                
                Text(subtitle)
                    .customFont(.body, fontSize: 14)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Always show the Active status for all cards
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.button)
                    Text("Active")
                        .font(.caption)
                        .foregroundColor(.button)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 1)
    }
}

struct SelectIDView_Previews: PreviewProvider {
    static var previews: some View {
        WalletIDView(
            showBottomSheet: .constant(false),
            navigateToPassportDetails: .constant(false),
            selectedID: .constant(nil)
        )
    }
}
