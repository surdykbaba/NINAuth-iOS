//
//  IDmodal.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 12/05/2025.
//

import SwiftUI

struct IDSelectionScreen: View {
    @State private var selectedIDType: String?
    @State private var navigateToScanner = false
    @State private var selectedCategory: String? = nil
    @State private var showSheet = false
    
    let items = [
        (icon: "digital", title: "Digital Government Services", description: "Store your digital IDs for easy access to government services."),
        (icon: "driving", title: "Driving and Transport", description: "Keep your transport cards ready for quick use."),
        (icon: "tagcard", title: "Tax, Insurance and Benefits", description: "Manage your tax IDs, insurance info, and benefit cards."),
        (icon: "finance", title: "Financial Services", description: "Add your financial credentials to ease banking and loan verifications."),
        (icon: "member", title: "Memberships", description: "Add for easy access to social and professional programs.")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select an ID to add")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top)
            
            List(items, id: \.title) { item in
                Button(action: {
                    selectedCategory = item.title
                    showSheet = true
                }) {
                    HStack(spacing: 16) {
                        Image(item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .background(Color(.systemGray6))
                            .frame(width: 61, height: 61)
                            .cornerRadius(30.5)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(.plain)
            
            NavigationLink(destination: ScanDocumentView(), isActive: $navigateToScanner) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: {
            // Clean up when sheet is dismissed
            selectedCategory = nil
        }) {
            if let category = selectedCategory {
                if #available(iOS 16.0, *) {
                    IDTypeSelectionScreen(
                        categoryTitle: category,
                        selectedIDType: $selectedIDType,
                        navigateToScanner: $navigateToScanner
                    )
                    .presentationDetents([.medium, .large])
                } else {
                    IDTypeSelectionScreen(
                        categoryTitle: category,
                        selectedIDType: $selectedIDType,
                        navigateToScanner: $navigateToScanner
                    )
                }
            }
        }
        .onChange(of: navigateToScanner) { newValue in
            if newValue {
                // Dismiss the sheet when navigation happens
                showSheet = false
            }
        }
    }
}

struct IDSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IDSelectionScreen()
        }
    }
}
