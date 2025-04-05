//
//  NinAuthSlider.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 03/04/2025.
//

import SwiftUI

struct NinAuthSlider: View {
    @Binding var value: Double
    var low: Int = 250
    var high: Int = 750
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let sliderHeight: CGFloat = 10
                    
                    ZStack {
                        Capsule()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.red, Color(.greenProgress)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(height: sliderHeight)
                            .frame(width: width)
                        

                    }
                    .frame(width: width, height: 40) 
                }
                .frame(height: 40)
                .overlay(
                    VStack {
                        Image("score_arrow")
                        .fixedSize(horizontal: false, vertical: true)
                        .alignmentGuide(HorizontalAlignment.leading) {
                            return $0[HorizontalAlignment.leading] - (geometry.size.width - $0.width) * (value - 0) / ( 10 - 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, 40), alignment: .bottom)
                .overlay(alignment: .leading) {
                    Text("\(low)")
                        .offset(y: 30)
                }
                .overlay(alignment: .trailing, content: {
                    Text("\(high)")
                        .offset(y: 30)
                })
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.bottom)
    }
}

#Preview {
    NinAuthSlider(value: .constant(6.0))
}
