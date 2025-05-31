
//
//  EmptyWallet.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 12/05/2025.

import SwiftUI


struct ServiceCategory: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let services: [DigitalService]
}

struct DigitalService: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let iconName: String
}

struct BannerItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let iconName: String
}


struct AddToWalletView: View {
    @State private var searchText = ""
    @State private var showMoreServices = false
    @State private var currentBannerIndex = 0
    @State private var selectedServiceID: String?
    @State private var navigateToDetails = false

    let bannerTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    let bannerItems: [BannerItem] = [
        BannerItem(title: "", subtitle: "", imageName: "maincard4", iconName: ""),
        BannerItem(title: "", subtitle: "", imageName: "maincard1", iconName: ""),
        BannerItem(title: "", subtitle: "", imageName: "maincard2", iconName: "")
    ]

    let governmentServices: [DigitalService] = [
        DigitalService(title: "Nigerian Passport", subtitle: "Government Services", imageName: "", iconName: "Immigration11"),
        DigitalService(title: "Voter's Card", subtitle: "Government Services", imageName: "voter_image", iconName: "Inec"),
        DigitalService(title: "State Residence Permit", subtitle: "Government Services", imageName: "residence_image", iconName: "StateCard")
    ]

    let drivingServices: [DigitalService] = [
        DigitalService(title: "Travel Card", subtitle: "Transport Services", imageName: "travel_image", iconName: "travel card"),
        DigitalService(title: "Driver's License", subtitle: "Transport Services", imageName: "license_image", iconName: "Drive 1"),
        DigitalService(title: "Nigeria Railway Coporation", subtitle: "Transport Services", imageName: "train_image", iconName: "railway")
    ]

    let additionalServices: [DigitalService] = [
        DigitalService(title: "Lagos Food Bank Initaitive", subtitle: "Financial Services", imageName: "tax_image", iconName: "food bank"),
        DigitalService(title: "PenCom ID", subtitle: "Healthcare Services", imageName: "health_image", iconName: "card9"),
        DigitalService(title: "I-fitness ID", subtitle: "Professional Services", imageName: "prof_image", iconName: "Gym"),
        DigitalService(title: "JTB Tax Identification Number", subtitle: "Healthcare Services", imageName: "health_image", iconName: "card10"),
        DigitalService(title: "Internal Revenue service", subtitle: "Healthcare Services", imageName: "health_image", iconName: "internal Revenue")
    ]

    var filteredGovernmentServices: [DigitalService] {
        searchText.isEmpty ? governmentServices : governmentServices.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var filteredDrivingServices: [DigitalService] {
        searchText.isEmpty ? drivingServices : drivingServices.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var filteredAdditionalServices: [DigitalService] {
        searchText.isEmpty ? additionalServices : additionalServices.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add to your Wallet")
                        .customFont(.headline, fontSize: 24)

                    Text("Keep all your daily IDs and passes in one place.")
                        .customFont(.body, fontSize: 16)
                }
                .padding(.horizontal)
                .padding(.top, 16)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search by name", text: $searchText)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                ScrollView {

                TabView(selection: $currentBannerIndex) {
                    ForEach(bannerItems.indices, id: \.self) { index in

                        BannerCardView(bannerItem: bannerItems[index])
                            .padding(.horizontal, 12)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 230)
                .onReceive(bannerTimer) { _ in
                    withAnimation {
                        currentBannerIndex = (currentBannerIndex + 1) % bannerItems.count
                    }
                }

               
                    VStack(alignment: .leading, spacing: 20) {
                        ServiceSectionView(title: "Government Services", services: filteredGovernmentServices) { service in
                            selectedServiceID = service.title
                            navigateToDetails = true
                        }

                        ServiceSectionView(title: "Driving and Transport", services: filteredDrivingServices) { service in
                            selectedServiceID = service.title
                            navigateToDetails = true
                        }

                        if showMoreServices || !searchText.isEmpty {
                            ServiceSectionView(title: "Additional Services", services: filteredAdditionalServices) { service in
                                selectedServiceID = service.title
                                navigateToDetails = true
                            }
                        }

                        if filteredGovernmentServices.isEmpty && filteredDrivingServices.isEmpty && filteredAdditionalServices.isEmpty && !searchText.isEmpty {
                            Text("No matching services found.")
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showMoreServices.toggle()
                            }
                        }) {
                            Text(showMoreServices ? "Show less services" : "Load more services")
                                .fontWeight(.medium)
                                .foregroundColor(.button)
                                .underline()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .padding(.horizontal)
                        

                        Spacer(minLength: 80)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                }
            }
            .background(
                NavigationLink(destination: PassportDetailsView(selectedID: selectedServiceID), isActive: $navigateToDetails) {
                    EmptyView()
                }
            )
        }
    }
}

struct BannerCardView: View {
    let bannerItem: BannerItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(bannerItem.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 8) {
                Text(bannerItem.title)
                    .font(.headline)
                    .foregroundColor(.white)
//                    .padding(.top,10)
                Text(bannerItem.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
//                    .padding(.top,10)
            }
            .padding()
//            .padding(.top,20)
        }
        .frame(height: 200)
    }
}

struct ServiceSectionView: View {
    let title: String
    let services: [DigitalService]
    let onServiceTap: (DigitalService) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .customFont(.subheadline, fontSize: 17)
                .padding(.horizontal)
                .padding(.top, 15)

            VStack(spacing: 6) { // Added 5 point spacing between service rows
                ForEach(services) { service in
                    ServiceRowView(digitalService: service)
                        .onTapGesture {
                            onServiceTap(service)
                        }
                    if service.id != services.last?.id {
                        Rectangle()
                            .foregroundColor(Color(hex: "#EDEFEC"))
                            .frame(height: 0.5)
                            .padding(.horizontal, 20) // Center the divider with equal padding on both sides
                    }
                }
            }
            .background(Color(hex: "#F6F8F6"))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top,10)
        }
    }
}

struct ServiceRowView: View {
    let digitalService: DigitalService

    var body: some View {
        HStack(spacing: 16) {
            Image(digitalService.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44, height: 26)

            Text(digitalService.title)
                .customFont(.subheadline, fontSize: 16)
            

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.primary)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.bg)
        .contentShape(Rectangle())
    }
}

struct AddToWalletView_Previews: PreviewProvider {
    static var previews: some View {
        AddToWalletView()
    }
}
