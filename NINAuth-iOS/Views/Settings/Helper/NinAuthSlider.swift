//
//  NinAuthSlider.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 03/04/2025.
//

import SwiftUI

struct NinAuthSlider: View {
    var value: Double = 8.0
    var low: Int = 250
    var high: Int = 750
    @State var screenWidth: CGFloat = 500
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                SwiftUISlider(width: screenWidth, value: value)
                    .overlay(
                        VStack {
                            Image("score_arrow")
                            .fixedSize(horizontal: false, vertical: true)
                            .alignmentGuide(HorizontalAlignment.leading) {
                                return $0[HorizontalAlignment.leading] - (geometry.size.width - $0.width) * (value - 0) / ( 10 - 0)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: 15)
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
                    .onAppear {
                        screenWidth = geometry.size.width
                    }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.bottom)
    }
}

#Preview {
    NinAuthSlider()
}
