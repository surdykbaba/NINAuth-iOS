//
//  DocumentView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 02/06/2025.
//

// Simple bottom sheet view for document selection

import SwiftUI
import PhotosUI
import UIKit

struct DocumentPickerView: View {
    @Binding var selectedDocument: String?
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    @State private var showingCamera = false
    @State private var showingFilePicker = false
    
    var body: some View {
        VStack(spacing: 0) {
 
            HStack {
                Text("Choose an action")
                    .customFont(.title, fontSize: 17)
                    .foregroundColor(.darkGrey)
                    .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .customFont(.title, fontSize: 17)
                        .foregroundColor(.darkGrey)
                        .padding(.top, 5)
                }
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 60) {

                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 70, height: 70)
                        
                        Image("Camera") // Make sure this is in your Assets.xcassets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            
                    }
                    
                    Text("Take a photo")
                        .customFont(.title, fontSize: 16)
                }
                .onTapGesture {
                    showingCamera = true
                }

                // Select a file
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 70, height: 70)
                        
                        Image("File")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                    }
                    
                    Text("Select a file")
                        .customFont(.title, fontSize: 16)
                }
                .onTapGesture {
                    showingFilePicker = true
                }
            }
            .padding(.top, 50)
           
        }
        .frame(height: 255)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedCorner(radius: 22, corners: [.topLeft, .topRight]))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        .sheet(isPresented: $showingCamera) {
            CameraView(selectedImage: $selectedImage, selectedDocument: $selectedDocument, isPresented: $isPresented)
        }
        .sheet(isPresented: $showingFilePicker) {
            FilePickerView(selectedDocument: $selectedDocument, isPresented: $isPresented)
        }
    }
}
