//
//  ScanDocument.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 13/05/2025.
//

import SwiftUI

struct ScanDocumentView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Scan your document")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 10)

            // Icon and Service Name
            VStack(spacing: 10) {
                Image("nigerian_coat_of_arms")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text("Nigerian Immigration Service")
                    .font(.body)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 30)
            
            // Information Section
            VStack(alignment: .leading, spacing: 15) {
                Text("The following information will be extracted")
                    .font(.headline)
                    .foregroundColor(.black)
                
                ForEach(["Surname", "Given Names", "Date of Birth", "Sex", "ID Photo", "Date of Issue", "Date of Expiry"], id: \.self) { info in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.button)
                        Text(info)
                            .font(.body)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Info Alert
            HStack(alignment: .center) {
                Image(systemName: "info.circle")
                    .foregroundColor(.button)
                Text("You will need to perform facial \nverification to complete this process.")
                    .foregroundColor(.black)
            }
            .frame(width: 368, height: 81)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.bottom, 20)
            
            // Button
            NavigationLink(destination: IDScannerView()) {
                Text("Scan document")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.button)
                    .cornerRadius(4)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 20)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ScanDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScanDocumentView()
        }
    }
}
