//
//  PhoneNumber.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 03/06/2025.
//


import SwiftUI

struct PhoneNumberView: View {
    @State private var showAddNumberModal = false
    @State private var showReportModal = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Phone Number")
                        .customFont(.title, fontSize: 24)
                    
                    Text("Add phone numbers to your NIN")
                        .customFont(.body, fontSize: 16)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
                
             
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        
                        ZStack {
                            Image("")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("08012345672")
                                .customFont(.subheadline, fontSize: 16)
                                
                            
                            Text("Linked on: August 12, 2024")
                                .customFont(.body, fontSize: 15)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                  
                    HStack {
                        Button(action: {
                            showReportModal = true
                        }) {
                            Text("I don't own this number")
                                .customFont(.body, fontSize: 15)
                                .foregroundColor(.red)
                               
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
              
                Button(action: {
                    showAddNumberModal = true
                }) {
                    Text("Add Number")
                        .customFont(.title, fontSize: 18)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.button)
                        .cornerRadius(4)
                }
                .padding(.horizontal)
                .padding(.bottom, 34)
            }
           
        }
        .overlay(
            
            showAddNumberModal ?
            SheetView(isPresented: $showAddNumberModal) {
                AddPhoneNumberBottomSheet(isPresented: $showAddNumberModal)
            } : nil
        )
        .overlay(
            
            showReportModal ?
            SheetView(isPresented: $showReportModal) {
                ReportPhoneNumberBottomSheet(isPresented: $showReportModal)
            } : nil
        )
    }
}


struct SheetView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }
            
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // Handle bar
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.secondary.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    
                    content
                }
                .background(Color(.systemBackground))
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
}


struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}
