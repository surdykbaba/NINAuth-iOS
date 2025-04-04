//
//  ArchUISlider.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 04/04/2025.
//

import Foundation
import SwiftUI

struct ArchSlider: View {
    @State private var value: Double = 7
    private let thumbOffset: CGFloat = 20 // Slightly below the arc
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let radius = width / 2 - 20
                
                ZStack {
                    ArcShape()
                        .stroke(
                            LinearGradient(
                            gradient: Gradient(colors: [.red, .green]),
                            startPoint: .leading,
                            endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: width, height: radius)
                    
                    ThumbView(rotationAngle: thumbRotationAngle())
                        .position(thumbPosition(in: geometry.size))
//                        .gesture(DragGesture()
//                            .onChanged { gesture in
//                                updateValue(from: gesture.location, in: geometry.size)
//                            }
//                        )
                    
                    VStack {
                        Text("\(550)")
                            .customFont(.largeTitle, fontSize: 56)
                        
                        Text("ID INTEGRITY INDEX")
                    }
                }
                .frame(width: width, height: radius)
            }
            .frame(height: 150) 
            
        }
        .padding()
    }
    
    private func thumbPosition(in size: CGSize) -> CGPoint {
        let width = size.width
        let radius = width / 2 - 20
        let normalizedValue = value / 10
        let angle = Angle.degrees(180 * normalizedValue)

        let x = width / 2 + radius * cos(angle.radians - .pi)
        let y = radius + radius * sin(angle.radians - .pi) + thumbOffset
        
        return CGPoint(x: x, y: y)
    }
    
    private func thumbRotationAngle() -> Angle {
        let normalizedValue = value / 10 // Convert 0-10 range to 0-1
        return Angle.degrees(180 * normalizedValue - 90)
    }
    
    
    private func updateValue(from location: CGPoint, in size: CGSize) {
        let width = size.width
        let radius = width / 2 - 20
        let center = CGPoint(x: width / 2, y: radius)
        
        let dx = location.x - center.x
        let dy = location.y - center.y
        let angle = atan2(dy, dx)
        
        //var newValue = (1 - (angle + .pi) / .pi) * 10
        var newValue = (angle / .pi) * 10
        newValue = max(0, min(10, newValue))
        
        value = newValue
    }
}

struct ArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = rect.width / 2 - 20
        path.addArc(center: CGPoint(x: rect.width / 2, y: radius),
                    radius: radius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: false)
        return path
    }
}


struct ThumbView: View {
    var rotationAngle: Angle
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .shadow(radius: 5)
            
            Image(systemName: "arrowtriangle.up.fill") // Arrow icon
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .rotationEffect(rotationAngle)
        }
    }
}

struct ContentView: View {
    var body: some View {
        ArchSlider()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
