//
//  SelectID.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 16/05/2025.
//

import SwiftUI

struct SelectIDView: View {
    struct IDCard: Identifiable {
        let id = UUID()
        let title: String
        let agency: String
        let imageName: String
        let isActive: Bool
    }

    let idCards = [
        IDCard(title: "Nigerian Passport", agency: "Nigeria Immigration Services", imageName: "passport", isActive: true),
        IDCard(title: "Voter’s Card", agency: "Independent National Electoral Commission", imageName: "votersCard", isActive: true),
        IDCard(title: "Driver’s License", agency: "Federal Road Safety Corps", imageName: "driversLicense", isActive: true),
        IDCard(title: "Lagos State Residence Permit", agency: "Lagos State Resident Registration Agency", imageName: "lagosPermit", isActive: true)
    ]

    @State private var searchText: String = ""

    var filteredCards: [IDCard] {
        if searchText.isEmpty {
            return idCards
        } else {
            return idCards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Title and Subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text("Select an ID")
                        .font(.title2).bold()
                    Text("Select an ID to add to your wallet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Search Bar
                HStack {
                    TextField("Search ID", text: $searchText)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // ID Cards
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredCards) { card in
                            HStack(spacing: 20) {
                                Image(card.imageName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(card.title)
                                        .font(.headline)
                                    Text(card.agency)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    if card.isActive {
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(Color.button)
                                                .frame(width: 8, height: 8)
                                            Text("Active")
                                                .font(.caption)
                                                .foregroundColor(.button)
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    
                }
                
                // Continue Button
                Button(action: {
                    // Continue action
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.button)
                        .cornerRadius(4)
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
}
#Preview {
    SelectIDView()
        .environmentObject(AppState())
}
