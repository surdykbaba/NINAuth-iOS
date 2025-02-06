//
//  HomeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var selected: PickerOptions = .digitalID

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.gray.opacity(0.1))
        UISegmentedControl.appearance().backgroundColor = UIColor.white
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .font:UIFont.systemFont(ofSize: 17, weight: .light),
            ], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .font:UIFont.systemFont(ofSize: 17, weight: .semibold),
            ], for: .selected)
    }

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

extension UISegmentedControl {
  override open func didMoveToSuperview() {
     super.didMoveToSuperview()
     self.setContentHuggingPriority(.defaultLow, for: .vertical)
   }
}

extension Font {
  init(_ uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}

enum PickerOptions: String, CaseIterable {
    case digitalID = "My Digital ID"
    case scanQR = "Scan QR "
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
