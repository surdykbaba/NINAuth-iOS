//
//  LinkedIDModal.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/04/2025.
//

import SwiftUI

import SwiftUI

struct LinkedIDsModalView: View {
    @Binding var showSheet: Bool
    @Binding var goToLinkID: Bool
    @Binding var score: Double
    @Binding var scoreToDisplay: Int
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Close Button
            HStack {
                Spacer()
                Button(action: {
                    showSheet.toggle()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            
            // Circular ID Integrity Index
            ArchSlider(value: score, displayValue: scoreToDisplay)
            
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
                    LinkedIDItem(title: "Bank Verification Number")
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
            .padding(.bottom)
        }
        .padding()
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
        LinkedIDsModalView(showSheet: .constant(true), goToLinkID: .constant(false), score: .constant(6), scoreToDisplay: .constant(600))
    }
}
