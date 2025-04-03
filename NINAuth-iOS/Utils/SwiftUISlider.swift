//
//  SwiftUISlider.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 03/04/2025.
//

import Foundation
import SwiftUI

struct SwiftUISlider: UIViewRepresentable {
    
    @State var width: CGFloat = 400
    var maxValue: Int = 10

    var value: Double = 6.0

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: width, height: 10))
//        slider.setThumbImage(UIImage(named: "indicator"), for: .normal)
        slider.maximumValue = Float(maxValue)
        slider.value = Float(value)
        let tgl = CAGradientLayer()
        let frame = CGRect(x: 0.0, y: 0.0, width: slider.bounds.width, height: 10.0 )
        tgl.frame = frame
//UIColor.yellow.cgColor,
        tgl.colors = [UIColor.red.cgColor, UIColor(named: "green_progress")!.cgColor]

        tgl.borderWidth = 1.0
        tgl.borderColor = UIColor.clear.cgColor
        tgl.cornerRadius = 5.0

        tgl.endPoint = CGPoint(x: 1.0, y:  1.0)
        tgl.startPoint = CGPoint(x: 0.0, y:  1.0)

        UIGraphicsBeginImageContextWithOptions(tgl.frame.size, false, 0.0)
        tgl.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        slider.setMaximumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)
        slider.setMinimumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero),  for: .normal)

//        let layerFrame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = CGPath(rect: layerFrame, transform: nil)
//        shapeLayer.fillColor = UIColor.black.cgColor

//        let thumb = CALayer.init()
//        thumb.frame = layerFrame
//        thumb.addSublayer(shapeLayer)
//
//        UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
//
//        thumb.render(in: UIGraphicsGetCurrentContext()!)
//        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()

        slider.setThumbImage(UIImage(), for: .normal)
        slider.setThumbImage(UIImage(), for: .highlighted)
        slider.isUserInteractionEnabled = false

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        // Coordinating data between UIView and SwiftUI view
        uiView.value = Float(self.value)
    }

}

#Preview {
    SwiftUISlider()
}
