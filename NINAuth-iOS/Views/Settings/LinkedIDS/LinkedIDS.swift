//
//  LinkedIDS.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/06/2025.
//

import SwiftUI

struct IDsView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    Text("Linked IDs")
                        .customFont(.title, fontSize: 24)
                    
                    Text("View other functional IDs linked to your NIN")
                        .customFont(.body, fontSize: 16)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
                
                // List items
                VStack(spacing: 10) {
                    // Phone Number
                    NavigationLink(destination:PhoneNumberView ()) {
                        HStack {
                            Image("mobile")
                                .resizable()
                                .scaledToFit()
                                
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)

                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Phone Number")
                                    .customFont(.subheadline, fontSize: 16)
                                
                                Text("1 phone number linked")
                                    .customFont(.body, fontSize: 15)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 8)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Email Address
                    NavigationLink(destination:PhoneNumberView ()) {
                        HStack {
                            Image("email")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Email Address")
                                    .customFont(.subheadline, fontSize: 16)
                                
                                Text("1 email address linked")
                                    .customFont(.body, fontSize: 15)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 8)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Address Information
                    NavigationLink(destination: updateAddressView()) {
                        HStack {
                            Image("Address")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Address Information")
                                    .customFont(.subheadline, fontSize: 16)
                                
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 6, height: 6)
                                    
                                    Text("Address not linked")
                                        .customFont(.body, fontSize: 15)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.leading, 8)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            
        }
        
    }
}

struct IDsView_Previews: PreviewProvider {
    static var previews: some View {
        IDsView()
    }
}
