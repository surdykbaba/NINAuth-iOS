//
//  Passpot.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 18/05/2025.
//


import SwiftUI
import CoreImage.CIFilterBuiltins

struct PassportView: View {
    
    @State private var showMenu = false
    @State private var showQRCode = false
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 48, height: 48)
                                .shadow(radius: 4)
                            
                            Image(systemName: "ellipsis")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("Nigerian Passport")
                            .customFont(.headline, fontSize: 24)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        
                        ZStack {
                            Image("card4")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .cornerRadius(16)
                            
                            Spacer()
                        }
                        .frame(height: 220)
                        .padding(.horizontal, 24)
                        
                        
                        Button(action: {
                            showQRCode = true
                        }) {
                            HStack {
                                Text("Share by QR code")
                                    .customFont(.headline, fontSize: 17)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        
                        VStack(spacing: 0) {
                            
                            HStack {
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Omotunde Aisha Nkechi")
                                        .customFont(.headline, fontSize: 17)
                                    
                                    HStack {
                                        Text("ID: B2635223")
                                            .foregroundColor(.gray)
                                        
                                        
                                        Button(action: {
                                            
                                            UIPasteboard.general.string = "B2635223"
                                        }) {
                                            HStack(spacing: 4) {
                                                Text("Copy")
                                                    .foregroundColor(.button)
                                                Image(systemName: "doc.on.doc")
                                                    .foregroundColor(.button)
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(16)
                                            .foregroundColor(.gray)
                                    )
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 24)
                            
                            Divider()
                                .padding(.horizontal, 24)
                            
                            
                            VStack(spacing: 24) {
                                makeInfoRow(label: "Date of Birth", value: "10/02/1984")
                                makeInfoRow(label: "Sex", value: "Female")
                                makeInfoRow(label: "Date of Issue", value: "27/06/2024")
                                makeInfoRow(label: "Date of Expiry", value: "26/06/2029")
                                makeInfoRow(label: "Issuer", value: "Nigerian Immigration Service")
                                makeInfoRow(label: "Authority", value: "FCT Abuja")
                            }
                            .padding(.vertical, 24)
                            
                        }
                        .customFont(.body, fontSize: 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                            
                        )
                        .padding(.horizontal, 24)
                    }
                }
                
                
                Button(action: {
                    
                }) {
                    Text("Done")
                        .customFont(.title, fontSize: 18)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.button)
                        .cornerRadius(4)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
            
            
            if showMenu {
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: "wallet.pass")
                                Text("Cash back Rewards")
                                    .foregroundColor(.black)
                                    .customFont(.headline, fontSize: 14)
                            }
                            
                            Divider()
                            
                            HStack(spacing: 6) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                Text("Delete ID")
                                    .foregroundColor(.red)
                                    .customFont(.headline, fontSize: 14)
                            }
                        }
                        .padding(12)
                        .frame(width: 180)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .padding(.trailing, 12)
                        .padding(.top, 12)
                        
                    }
                    Spacer()
                }
                .background(
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                            }
                        }
                )
            }
            
            ZStack {
                if showQRCode {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showQRCode = false
                            }
                        }
                    
                    VStack {
                        Spacer()  // Push everything down to the bottom
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            showQRCode = false
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(.horizontal, 24)
                                
                                Text("Nigerian Passport")
                                    .customFont(.headline, fontSize: 18)
                                
                                QRCodeView(data: """
                                    Nigerian Passport
                                    Name: Omotunde Aisha Nkechi
                                    ID: B2635223
                                    DOB: 10/02/1984
                                    Sex: Female
                                    Issue Date: 27/06/2024
                                    Expiry Date: 26/06/2029
                                    """)
                                .frame(width: 240, height: 240)
                                
                                HStack(alignment: .top, spacing: 16) {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 8, height: 8)
                                        .padding(.top, 6)
                                    
                                    Text("Allow organizations scan the QR code to securely access your digital document. Your data is protected and shared only with your consent.")
                                        .customFont(.body, fontSize: 14)
                                        .foregroundColor(.black.opacity(0.8))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .padding(.horizontal, 16)
                                
                                Button(action: {
                                    withAnimation {
                                        showQRCode = false
                                    }
                                }) {
                                    Text("Got it")
                                        .customFont(.title, fontSize: 18)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color.button)
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 24)
                            }
                            .background(Color.white)
                            .cornerRadius(24, corners: [.topLeft, .topRight])
                        }
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.7) // limit max height if you want
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut, value: showQRCode)
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
    
    
    func makeInfoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .medium))
        }
        .padding(.horizontal, 24)
    }
}

// QR Code generator
struct QRCodeView: View {
    let data: String
    
    var body: some View {
        Image(uiImage: generateQRCode(from: data))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}


struct PassportView_Previews: PreviewProvider {
    static var previews: some View {
        PassportView()
    }
}

