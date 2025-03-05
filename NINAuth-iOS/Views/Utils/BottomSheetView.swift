//
//  BottomSheetView.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/03/2025.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: Content
        
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if isPresented {
                    Color(.darkGrey)
                        .opacity(0.9)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    
                    VStack {
                        //contentView
                        content
                            .padding(.bottom, 50)
                    }
                    .frame(maxWidth: .infinity)
                    //.frame(maxHeight: geometry.size.height - 50)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .animation(.easeInOut, value: isPresented)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
//            handle
//                .padding(.top, 6)
            content
                .padding(.top, 0)
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .cornerRadius(12, corners: [.topLeft, .topRight])
    }

    private var handle: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.gray)
            .frame(width: 48, height: 5)
    }
}

#Preview {
    BottomSheetView(isPresented: .constant(true)) {
        Rectangle().fill(Color.red)
            .frame(height: 200)
    }
}
