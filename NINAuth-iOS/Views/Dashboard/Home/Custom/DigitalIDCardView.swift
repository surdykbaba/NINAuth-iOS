//
//  UserQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 15/04/2025.
//
//import SwiftUI
//import RealmSwift
//
//struct DigitalIDCardView: View {
//    @ObservedResults(User.self) var user
//
//    var body: some View {
//        // Using GeometryReader to ensure proper sizing and prevent layout issues
//        GeometryReader { geometry in
//            VStack(alignment: .center, spacing: 0) {
//                Text("federal_republic_of_nigeria")
//                    .customFont(.title, fontSize: 14)
//                    .foregroundColor(Color.button)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.top, 20)
//                    .padding(.trailing, 5)
//
//                Text("national_identity_card")
//                    .customFont(.title, fontSize: 12)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.top, 4)
//                    .padding(.trailing, 5)
//
//                HStack(alignment: .top, spacing: 0) {
//                    VStack {
//                        Spacer()
//                        ZStack {
//                            // Using the GifImage instead of animated Image
//                            GifImage("ninc")
//                                .frame(width: 35, height: 35)
//                                .clipShape(RoundedRectangle(cornerRadius: 5))
//                              
//                            
//                           
//                        }
//                    }
//                    .frame(width: 53, alignment: .bottom)
//                    .padding(.leading, 5)
//                    .padding(.bottom, 10)
//                    
//                    VStack(alignment: .leading, spacing: 4) {
//                        doubleTextView(title: "SURNAME", subtitle: user.first?.last_name ?? "")
//                        doubleTextView(title: "FIRST NAME", subtitle: user.first?.first_name ?? "")
//                        doubleTextView(title: "MIDDLE NAME", subtitle: user.first?.middle_name ?? "")
//                        doubleTextView(title: "GENDER", subtitle: user.first?.gender ?? "")
//                    }
//                    .frame(maxWidth: 100)
//                    .padding(.trailing, 5)
//
//                    VStack(alignment: .leading, spacing: 4) {
//                        doubleTextView(
//                            title: "NATIONAL IDENTITY NUMBER",
//                            subtitle: {
//                                let nin = user.first?.nin ?? ""
//                                if nin.count >= 11 {
//                                    let masked = String(repeating: "*", count: 7) + nin.suffix(4)
//                                    return masked
//                                } else {
//                                    return nin
//                                }
//                            }()
//                        )
//                        doubleTextView(
//                            title: "STATE OF ORIGIN",
//                            subtitle: (user.first?.origin_state?.isEmpty == false ? user.first?.origin_state : "N/A") ?? "N/A"
//                        )
//                        doubleTextView(
//                            title: "LGA",
//                            subtitle: (user.first?.origin_local_government?.isEmpty == false ? user.first?.origin_local_government : "N/A") ?? "N/A"
//                        )
//                        doubleTextView(title: "DATE OF BIRTH", subtitle: user.first?.getDOB() ?? "")
//                    }
//                    .padding(.leading, 16)
//                    .padding(.trailing, 5)
//                    .frame(maxWidth: 150)
//
//                    Spacer()
//                }
//                .padding(.top, 19)
//                .frame(maxWidth: .infinity)
//
//                Spacer()
//            }
//            .padding(.top, 10)
//            // Fixed height with maxWidth to prevent unwanted layout shifts
//            .frame(width: geometry.size.width, height: 242)
//            .background(
//                Image("NinID_Front_new")
//                    .resizable()
//                    .frame(width: 360, height: 235)
//                    .clipped()
//            )
//            .overlay(
//                VStack {
//                    Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
//                        .resizable()
//                        .scaledToFill()
//                        .cornerRadius(5)
//                        .frame(width: 80, height: 45)
//                }
//                .frame(width: 64, height: 63)
//                .background(Color.white)
//                .padding(.bottom, 34)
//                .offset(x:-5)
//                .padding(.trailing, 10),
//                alignment: .bottomTrailing
//                
//            )
//            // Disable any automatic animations that might cause layout issues
//            .animation(nil)
//        }
//        // Set a fixed height for GeometryReader
//        .frame(height: 242)
//        // Disable animations at the container level
//        .animation(nil)
//    }
//
//    func doubleTextView(title: String, subtitle: String) -> some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Text(title)
//                .customFont(.body, fontSize: 9)
//                .foregroundColor(Color(.cardLabel))
//                .padding(.top, 1)
//            Text(subtitle)
//                .customFont(.title, fontSize: 12)
//                .foregroundColor(Color(.text))
//        }
//        .multilineTextAlignment(.leading)
//    }
//}
//
//#Preview {
//    DigitalIDCardView()
//}


import SwiftUI
import RealmSwift

struct DigitalIDCardView: View {
    @ObservedResults(User.self) var user

    var body: some View {
        // Using GeometryReader to ensure proper sizing and prevent layout issues
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                // Main content - centered
                HStack(spacing: 0) {
                    // Profile image on the left in grayscale
                    VStack {
                        Spacer() // Pushes the content to the bottom

                        Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 50)
                            .cornerRadius(5)
                            .grayscale(1.0) // Convert to grayscale
                            .padding(.bottom, 8)
                    }
                    .frame(width: 90)
                    .padding(.leading, -10)

                    
                    // Content shifted left by 20
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .top, spacing: 5) {
                            VStack(alignment: .leading, spacing: 4) {
                                doubleTextView(title: "SURNAME", subtitle: user.first?.last_name ?? "")
                                doubleTextView(title: "FIRST NAME", subtitle: user.first?.first_name ?? "")
                                doubleTextView(title: "MIDDLE NAME", subtitle: user.first?.middle_name ?? "")
                                doubleTextView(title: "GENDER", subtitle: user.first?.gender ?? "")
                            }
                            .frame(width: 110)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                doubleTextView(
                                    title: "NATIONAL IDENTITY NUMBER",
                                    subtitle: {
                                        let nin = user.first?.nin ?? ""
                                        if nin.count >= 11 {
                                            let masked = String(repeating: "*", count: 7) + nin.suffix(4)
                                            return masked
                                        } else {
                                            return nin
                                        }
                                    }()
                                )
                                doubleTextView(
                                    title: "STATE OF ORIGIN",
                                    subtitle: (user.first?.origin_state?.isEmpty == false ? user.first?.origin_state : "N/A") ?? "N/A"
                                )
                                doubleTextView(
                                    title: "LGA",
                                    subtitle: (user.first?.origin_local_government?.isEmpty == false ? user.first?.origin_local_government : "N/A") ?? "N/A"
                                )
                                doubleTextView(title: "DATE OF BIRTH", subtitle: user.first?.getDOB() ?? "")
                                
                                doubleTextView(
                                    title: "Document Number",
                                    subtitle: {
                                        let nin = user.first?.id_number ?? ""
                                        return nin
//                                        if nin.count >= 6 {
//                                            let first3 = nin.prefix(3)
//                                            let last3 = nin.suffix(3)
//                                            return "\(first3)\(last3)"
//                                        } else {
//                                            return nin
//                                        }
                                    }()
                                )

                            }
                            .frame(width: 130)
                        }
                        .padding(.top, 10) // Moved down by increasing top padding
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Left alignment
                    .padding(.leading, -20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                // Added date of issue and expiry at the bottom
                HStack(spacing: 2) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("DATE OF ISSUE/")
                            .customFont(.body, fontSize: 5)
                            .foregroundColor(Color(hex: "#0D682B"))
                        Text("06.05.2025/")
                            .customFont(.title, fontSize: 7)
                            .foregroundColor(Color(.text))
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("DATE OF EXPIRY")
                            .customFont(.body, fontSize: 5)
                            .foregroundColor(Color(hex: "#0D682B"))
                        Text("06.05.2029")
                            .customFont(.title, fontSize: 7)
                            .foregroundColor(Color(.text))
                    }
                }
                .padding(.top, 5)
                .padding(.bottom, 30)
                .offset(x:-33)

                Spacer()
            }
            .padding(.top, 60)
            // Fixed height with maxWidth to prevent unwanted layout shifts
            .frame(width: geometry.size.width, height: 253)
            .background(
                Image("NINAUTHfront")
                    .resizable()
                    .frame(width: 360, height: 235)
                    .clipped()
            )
            .overlay(
                // Original color image in bottom right
                VStack {
                    Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(5)
                        .frame(width: 70, height: 35)
                        
                }
                .frame(width: 54, height: 53)
                .background(Color.white)
                .padding(.bottom, 30)
                .offset(y: -50) // Adjusted position
                .padding(.trailing, 20),
                alignment: .bottomTrailing
            )
            // Disable any automatic animations that might cause layout issues
            .animation(nil)
        }
        // Set a fixed height for GeometryReader
        .frame(height: 242)
        // Disable animations at the container level
        .animation(nil)
    }

    func doubleTextView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(.body, fontSize: 7)
                .foregroundColor(Color(hex: "#0D682B"))
                .padding(.top, -1)
            Text(subtitle)
                .customFont(.title, fontSize: 10)
                .foregroundColor(Color(.text))
        }
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    DigitalIDCardView()
}
