//
//  HomeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var selected: PickerOptions = .digitalID

    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            VStack {
                Picker("", selection: $selected) {
                    ForEach(PickerOptions.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .frame(height: 60)
                .padding()

                ChosenPickerView(option: selected)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Home")
                    .customFont(.headline, fontSize: 24)
            }
        }
    }
}

enum PickerOptions: String, CaseIterable {
    case digitalID = "My Digital ID"
    case scanQR = "Scan QR"
}

struct ChosenPickerView: View {
    var option: PickerOptions

    var body: some View {
        switch option {
        case .digitalID:
            DigitalIDView()
        case .scanQR:
            ScanQRCodeView()
        }
    }
}

#Preview {
    HomeView()
}
