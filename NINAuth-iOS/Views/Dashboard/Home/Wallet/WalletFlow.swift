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
    @State private var navigateToPassportConfirmation = false
    @State private var selectedID: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                ModalIDView(showBottomSheet: $showBottomSheet, selectedID: $selectedID)
                
                // Hidden NavigationLinks for navigation
                NavigationLink(
                    destination: PassportDetailsView(navigateToPassportConfirmation: $navigateToPassportConfirmation),
                    isActive: $navigateToPassportDetails,
                    label: { EmptyView() }
                )
                
                NavigationLink(
                    destination: PassportConfirmationView(),
                    isActive: $navigateToPassportConfirmation,
                    label: { EmptyView() }
                )
            }
            .sheet(isPresented: $showBottomSheet) {
                SelectServiceView(
                    showBottomSheet: $showBottomSheet,
                    navigateToPassportDetails: $navigateToPassportDetails
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack style for consistent behavior
    }
}


struct ModalIDView: View {
    @Binding var showBottomSheet: Bool
    @Binding var selectedID: String?
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
           
            Text("Select an ID")
                .customFont(.title, fontSize: 24)
                
            
            Text("Select an ID to add to your wallet")
                .customFont(.subheadline, fontSize: 17)
                
            
            // Search bar
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
                
                Button(action: {}) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.05), radius: 2)
                }
            }
            
            // ID List
            ScrollView {
                VStack(spacing: 16) {
                    // Nigerian Passport
                    IDCard(
                        icon: "Nigeria_passport",
                        title: "Nigerian Passport",
                        subtitle: "Nigeria Immigration Services",
                        isActive: true
                    )
                    .onTapGesture {
                        selectedID = "Nigerian Passport"
                        showBottomSheet = true
                    }
                    
                    // Voter's Card
                    IDCard(
                        icon: "Voters_card",
                        title: "Voter's Card",
                        subtitle: "Independent National Electoral Commission",
                        isActive: true
                    )
                    .onTapGesture {
                        selectedID = "Voter's Card"
                        showBottomSheet = true
                    }
                    
                    // Driver's License
                    IDCard(
                        icon: "driving",
                        title: "Driver's License",
                        subtitle: "Federal Road Safety Corps",
                        isActive: true
                    )
                    .onTapGesture {
                        selectedID = "Driver's License"
                        showBottomSheet = true
                    }
                    
                    // Lagos State Residence Permit
                    IDCard(
                        icon: "Lagos",
                        title: "Lagos State Residence Permit",
                        subtitle: "Lagos State Resident Registration Agency",
                        isActive: true
                    )
                    .onTapGesture {
                        selectedID = "Lagos State Residence Permit"
                        showBottomSheet = true
                    }
                }
            }
            
            Spacer()
            
            // Continue Button
            Button(action: {}) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.button)
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
    }
}


struct IDCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Using custom image extension for icons
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

                    
                    
                    
                
                if isActive {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.button)
                        Text("Active")
                            .font(.caption)
                            .foregroundColor(.button)
                    }
                    .padding(.top, 4)
                    .background(Color.bg)
                    .cornerRadius(8)
                    
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2)
    }
}


struct SelectServiceView: View {
    @Binding var showBottomSheet: Bool
    @Binding var navigateToPassportDetails: Bool
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            HStack {
                Button(action: {
                    showBottomSheet = false
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            Text("Select a service")
                .customFont(.title, fontSize: 24)
                .frame(maxWidth: .infinity, alignment: .leading)

            
            .padding(.bottom, 8)
            
            // Service List
            ScrollView {
                VStack(spacing: 0) {
                    // Digital Government Services
                    ServiceRow(
                        icon: "government",
                        iconBackground: Color.green.opacity(0.2),
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
                        icon: "transport",
                        iconBackground: Color.blue.opacity(0.2),
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
                        icon: "firs",
                        iconBackground: Color.green.opacity(0.2),
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
                        icon: "Nibss",
                        iconBackground: Color.green.opacity(0.2),
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
                        icon: "Members",
                        iconBackground: Color.gray.opacity(0.2),
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
        .padding()
        .background(Color.white)
    }
}


struct ServiceRow: View {
    let icon: String
    let iconBackground: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
//                Circle()
//                    .fill(iconBackground)
//                    .frame(width: 50, height: 50)
                
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .customFont(.title, fontSize: 18)
                
                Text(description)
                    .customFont(.body, fontSize: 15)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.textBlackSec)
        }
        .padding(.vertical, 16)
    }
}


struct PassportDetailsView: View {
    @Binding var navigateToPassportConfirmation: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
        
                
               
                ZStack(alignment: .bottomTrailing) {
                   
                    ZStack {
                        Image("card1")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                        
                    }

                }
               
                
                // Content
                VStack(alignment: .leading, spacing: 16) {
                    Text("Nigerian Passport")
                        .customFont(.title, fontSize: 20)
                    
                    Text("Your Nigerian passport is a secure ID for local and international services, not just travel.")
                        .customFont(.body, fontSize: 16)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 16)
                    
                    
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 60, height: 60)
                            
                            Image("pass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Why Your Passport Matters")
                                .customFont(.title, fontSize: 18)
                            
                            Text("Your passport is key for travel, identification, and accessing important services.")
                                .customFont(.body, fontSize: 15)
                                .foregroundColor(.secondary)
                                
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Using Your Passport with NINAuth
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 60, height: 60)
                            
                            Image("pass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Using Your Passport with NINAuth")
                                .customFont(.title, fontSize: 18)
                            
                            Text("Linking your passport on NINAuth makes verification faster and more secure.")
                                .customFont(.body, fontSize: 15)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                    
                  
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 60, height: 60)
                            
                            Image("pass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("What You Gain")
                                .customFont(.title, fontSize: 18)
                            
                            Text("Enjoy faster access, verified identity, and secure data protection.")
                                .customFont(.body,fontSize: 15)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Spacer()
                
              
                Button(action: {
                    navigateToPassportConfirmation = true
                }) {
                    Text("Check eligibility")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.button)
                        .cornerRadius(4)
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}


struct PassportConfirmationView: View {
    @State private var agreeToSave = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // Close button
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.bottom, 10)
            
            
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 2)
                    
                
                
                Image( "Nigeria_passport")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .foregroundColor(.green)
            }
            .padding(.bottom, 5)
            
            
            Text("Nigerian Passport Details Found")
                .customFont(.title, fontSize: 20)
                .multilineTextAlignment(.center)
            
           
            Text("Your Nigerian Passport, linked to your NIN, has been successfully retrieved.")
                .customFont(.body, fontSize: 16)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
                .multilineTextAlignment(.center)


            
            // Information to be extracted
            VStack(alignment: .leading, spacing: 16) {
                Text("The following information will be extracted")
                    .customFont(.title, fontSize: 17)
                    .padding(.bottom, 8)
                
                ForEach(["Surname", "Given Names", "Date of Birth", "Sex", "ID Photo", "Date of Issue", "Date of expiry"], id: \.self) { item in
                    HStack(spacing: 12) {
                        Image("checks")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(item)
                            .customFont(.body, fontSize: 16)
                    }

                }
            }
            .padding()
            .background(Color(.secondaryGrayBackground))
            .cornerRadius(12)
            
            // Agreement checkbox
            HStack(alignment: .top, spacing: 12) {
                Button(action: {
                    agreeToSave.toggle()
                }) {
                    ZStack {
                        Rectangle()
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 24, height: 24)
                            .background(agreeToSave ? Color.green.opacity(0.1) : Color.white)
                        
                        if agreeToSave {
                            Image(systemName: "checkmark")
                                .foregroundColor(.button)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                }
                
                Text("I agree to save this information securely in your digital ID wallet.")
                    .customFont(.body, fontSize: 16)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 20)
            
        
            // Add to wallet button
            Button(action: {
                // Action to add to wallet
            }) {
                Text("Add to wallet")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.button)
                    .cornerRadius(4)
            }
            .disabled(!agreeToSave)
            .opacity(agreeToSave ? 1.0 : 0.7)
        }
        .padding()
        .background(Color.white)
        .navigationBarHidden(true)
    }
}




struct NINAuthFlow_Previews: PreviewProvider {
    static var previews: some View {
        NINAuthFlow()
    }
}

struct SelectIDView_Previews: PreviewProvider {
    static var previews: some View {
        ModalIDView(
            showBottomSheet: .constant(false),
            selectedID: .constant(nil)
        )
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

struct PassportDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PassportDetailsView(
            navigateToPassportConfirmation: .constant(false)
        )
    }
}

struct PassportConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        PassportConfirmationView()
    }
}
