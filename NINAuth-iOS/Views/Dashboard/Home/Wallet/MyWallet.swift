//
//  SelectID.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 17/05/2025.
//
import SwiftUI


struct HomeWallet: View {
    @State private var scrollOffset: CGFloat = 0
       @State private var timer: Timer?
    let cardWidth: CGFloat = 252  // Including padding and spacing
       let spacing: CGFloat = 10
       let cards = ["Newcard1", "Newcard1", "Newcard1"] // Example cards
    let documents = [
        ("Nigeria_passport", "Nigerian", "Passport"),
        ("Voters_card", "Voters", "Card"),
        ("driving", "Driving", "License")
    ]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Header
                Text("My Wallet")
                    .customFont(.title, fontSize: 17)
                    
                
                Text("Add your IDs to NINAuth Wallet")
                    .customFont(.subheadline, fontSize: 17)
                    .foregroundColor(.text)
                    .padding(.bottom, 8)
                
                // International Passport Card
                ZStack(alignment: .bottomLeading) {
                    GeometryReader { geometry in
                        Image("card1")
                            .resizable()
                            .frame(width: geometry.size.width, height: 229)
                            .cornerRadius(12)
                    }
                }
                .frame(height: 229)

                
                // Essential IDs
                Text("Essential IDs")
                    .font(.headline)
                    .padding(.top, 8)
            
                HStack(spacing: 12) {
                    ForEach(documents, id: \.0) { document in
                        VStack {
                            ZStack {
                                Image(document.0)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            
                            Text(document.1)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Text(document.2)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                }

                // Select A Service
                Text("Select A Service")
                    .font(.headline)
                    .padding(.top, 8)

                // Digital Government Services
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ZStack {
                            Image("Nigeria_passport")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Digital Government Services")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("Store your digital IDs for easy access to government services.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            // Immigration Service Card
                            
                                Image("Newcard1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 142)
                        
                            .padding(12)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            
                            // Road Safety Card
                            VStack(alignment: .leading) {
                                
                                    Image("Newcard1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 142)
                                
                                .padding(12)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                // Driving and Transport
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "car.fill")
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Driving and Transport")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("Keep your transport cards ready for quick use.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 12) {
                        // Lagos Card
                        VStack(alignment: .leading) {
                            Text("Lagos State Travel Card")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Text("Cowry")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(12)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        
                        // Railway Card
                        VStack(alignment: .leading) {
                            Text("Nigerian Railway Corporation")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(12)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(12)
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Tax, Insurance and Benefits
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Tax, Insurance and Benefits")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("Manage your tax IDs, insurance info, and benefit cards.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 12) {
                        // Tax Board Card
                        VStack(alignment: .leading) {
                            Text("Joint Tax Board")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("Tax Identity Card")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                        
                        // Pension Card
                        VStack(alignment: .leading) {
                            Text("National Pension Commission")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("Pencom ID")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(12)
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Financial Services
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Financial Services")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("Add your financial credentials to ease banking and loan verifications.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 12) {
                        // GT Bank Card
                        VStack(alignment: .leading) {
                            Text("GT Bank")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                ZStack {
                                    Rectangle()
                                        .fill(Color.orange)
                                        .frame(width: 24, height: 24)
                                        .cornerRadius(4)
                                    
                                    Text("GTCo")
                                        .font(.system(size: 8))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Text("Debit Card")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(12)
                        
                        // First Bank Card
                        VStack(alignment: .leading) {
                            Text("First Bank")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("Debit Card")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(12)
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Memberships
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Memberships")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("Add for easy access to social and professional programs.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 12) {
                        // Fitness Card
                        VStack(alignment: .leading) {
                            Text("F Fitness Gym")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("Membership Card")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                        
                        // 24Fitness Card
                        VStack(alignment: .leading) {
                            Text("24Fitness")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(12)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(12)
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .padding(16)
        }
//        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeWallet_Previews: PreviewProvider {
    static var previews: some View {
        HomeWallet()
    }
}
