//
//  Extensions.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 07/02/2025.
//

import SwiftUI

// UISegmentedControl for homeView appearance
extension UISegmentedControl {
  override open func didMoveToSuperview() {
     super.didMoveToSuperview()
     self.setContentHuggingPriority(.defaultLow, for: .vertical)
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
}

extension Font {
  init(_ uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
