//
//  DataLoaderView.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 22/02/2025.
//

import SwiftUI
import EasySkeleton

struct DataLoaderView: View {
    var body: some View {
        HStack(spacing: 0) {
            ProgressView()
                .frame(width: 65, height: 97)
                .skeletonable()
                .skeletonCornerRadius(16)
                .padding(11)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("                                  ")
                .skeletonable()
                .skeletonCornerRadius(16)
                .padding(.top, 16)
                
                Text("                             ")
                .skeletonable()
                .skeletonCornerRadius(16)
                
                Spacer()
                
                Text("                                    ")
                    .skeletonable()
                    .skeletonCornerRadius(16)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(11)
            
            Spacer()
        }
        //.background(Color("dark_grey"))
        .frame(maxHeight: 120)
        .cornerRadius(4)
    }
}

#Preview {
    DataLoaderView()
}
