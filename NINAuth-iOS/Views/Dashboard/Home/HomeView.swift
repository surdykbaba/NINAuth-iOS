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
    }
}

enum PickerOptions: String, CaseIterable {
    case digitalID = "my_digital_id"
    case scanQR = "scan_qr"
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
