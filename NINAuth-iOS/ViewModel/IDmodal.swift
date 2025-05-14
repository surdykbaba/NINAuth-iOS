//
//  IDTypeSelectionScreen.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 12/05/2025.
//

import SwiftUI

struct IDTypeSelectionScreen: View {
    let categoryTitle: String
    @Binding var selectedIDType: String?
    @Binding var navigateToScanner: Bool

    @State private var selectedOption = ""

    let categoryOptions: [String: [String]] = [
        "Digital Government Services": ["International Passport", "Driver's license", "Voter's ID", "Residence Permit"],
        "Financial Services": ["BVN Card", "Credit Card", "Bank Debit Card, Card"],
        "Tax, Insurance and Benefits": ["Tax ID", "TIN", "FIRS", "Virtual"],
        "Memberships": ["Polo", "Resident", "Landlord", "Tenant"],
        "Driving and Transport": ["Driver's license", "Vehicle Registration", "Transport Card"]
    ]

    var options: [String] {
        categoryOptions[categoryTitle] ?? []
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(categoryTitle)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option)
                    Spacer()
                    Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedOption == option ? Color.button : .gray)
                        .imageScale(.large)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedOption = option
                }
                .padding(.vertical, 8)
            }

            Spacer()

            Button(action: {
                if !selectedOption.isEmpty {
                    selectedIDType = selectedOption
                    navigateToScanner = true
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedOption.isEmpty ? Color.button : Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(selectedOption.isEmpty)
        }
        .padding()
        .onAppear {
            if let first = options.first {
                selectedOption = first
            }
        }
    }
}

#Preview {
    @State var selectedID: String? = nil
    @State var shouldNavigate = false

    return NavigationView {
        IDTypeSelectionScreen(
            categoryTitle: "Digital Government Services",
            selectedIDType: $selectedID,
            navigateToScanner: $shouldNavigate
        )
    }
}
