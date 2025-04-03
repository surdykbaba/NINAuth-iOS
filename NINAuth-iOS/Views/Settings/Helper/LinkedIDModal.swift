//
//  LinkedIDModal.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/04/2025.
//

import SwiftUI

import SwiftUI

struct LinkedIDsModalView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the modal
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Close Button
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            
            // Circular ID Integrity Index
            CircularIntegrityView(score: 550)
            
            // Integrity Index Explanation Box
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.black)
                
                Text("""
                Calculated from the IDs linked to your NIN, your Integrity Index reflects the completeness and reliability of your identity profile. The more verified IDs you link, the higher your index.
                """)
                .font(.footnote)
                .foregroundColor(.black)
            }
            .padding()
            .background(Color(.grayBackground))
            .cornerRadius(10)
            
            // Linked IDs List (Left Aligned)
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Linked IDs")
                        .font(.headline)
                    
                    LinkedIDItem(title: "Phone Number")
                    LinkedIDItem(title: "Tax Identification Number")
                    LinkedIDItem(title: "International Passport")
                }
                
                Spacer() 
            }
            
            // Button to Link More IDs
            Button(action: {
               
            }) {
                Text("Link More IDs")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("buttonColor"))
                    .cornerRadius(4)
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
    }
}

// Circular Progress View for ID Integrity Index
struct CircularIntegrityView: View {
    var score: Int
    
    var body: some View {
        ZStack {
            // Background Arc
            Circle()
                .trim(from: 0.2, to: 1) 
                .stroke(Color.red.opacity(0.3), lineWidth: 15)
                .rotationEffect(.degrees(135))
            
            // Foreground Arc
            Circle()
                .trim(from: 0.2, to: CGFloat(score) / 1000)
                .stroke(score > 700 ? Color.green : Color.orange, lineWidth: 15)
                .rotationEffect(.degrees(130))
            
            // Score Display
            VStack {
                Text("\(score)")
                    .font(.largeTitle)
                    .bold()
                
                Text("ID INTEGRITY INDEX")
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }
        .frame(width: 150, height: 150)
    }
}

// Linked ID Item
struct LinkedIDItem: View {
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.square")
                .foregroundColor(Color("buttonColor"))
            
            Text(title)
                .font(.body)
        }
    }
}

// Preview
struct LinkedIDsModalView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedIDsModalView()
    }
}
