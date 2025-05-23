////
////  StackedWallet.swift
////  NINAuth-iOS
////
////  Created by Arogundade Qoyum on 13/05/2025.
////
//import SwiftUI
//
//struct HomeWallet: View {
//    
//    
//    @State private var currentMainCardIndex = 0
//    @State private var mainCardTimer: Timer?
//    
//  
//    let cardWidth: CGFloat = 250
//    let cardSpacing: CGFloat = 5
//    
//   
//    let mainDisplayCards = ["banner2", "banner2", "banner2", "banner2", "banner2"]
//    let governmentCards = ["cardbanner", "cardbanner"]
//    let transportCards = ["card5", "card7"]
//    let taxCards = ["card9", "card10"]
//    let financialCards = ["card1", "card3"]
//    let membershipCards = ["card8", "card8"]
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                   
//                    Text("Add a service")
//                        .customFont(.headline, fontSize: 24)
//                    
//               
//                    GeometryReader { geometry in
//                        TabView(selection: $currentMainCardIndex) {
//                            ForEach(0..<mainDisplayCards.count, id: \.self) { index in
//                                NavigationLink(destination: PassportDetailsView(selectedID: mainDisplayCards[index])) {
//                                    Image(mainDisplayCards[index])
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .cornerRadius(12)
//                                        .frame(width: 395)
//                                        .padding(.horizontal, 20)
//                                }
//                                .tag(index)
//                            }
//                        }
//                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                        .onAppear {
//                            startMainCardTimer()
//                        }
//                        .onDisappear {
//                            mainCardTimer?.invalidate()
//                            mainCardTimer = nil
//                        }
//                    }
//                    .frame(height: 170)
//                    .cornerRadius(8)
//                    
//                    createServiceSection(
//                        title: "Digital Government Services",
//                        description: "Store your digital IDs for easy access into government services.",
//                        icon: "government_icon",
//                        cards: governmentCards
//                    )
//                    
//                    createServiceSection(
//                        title: "Driving and Transport",
//                        description: "Keep your transport cards ready for quick use.",
//                        icon: "car",
//                        cards: transportCards
//                    )
//                    
//                    createServiceSection(
//                        title: "Tax, Insurance and Benefits",
//                        description: "Manage your tax IDs, insurance info, and benefit cards.",
//                        icon: "tax",
//                        cards: taxCards
//                    )
//                    
//                    createServiceSection(
//                        title: "Financial Services",
//                        description: "Add your financial credentials to ease banking and loan verifications.",
//                        icon: "financial",
//                        cards: financialCards
//                    )
//                    
//                    createServiceSection(
//                        title: "Memberships",
//                        description: "Add for easy access to social and professional programs.",
//                        icon: "membership",
//                        cards: membershipCards
//                    )
//                }
//                .padding(16)
//            }
//            .background(Color(hex: "#F5F4F3"))
//            .navigationBarHidden(true)
//        }
//    }
//    
//    
//    func startMainCardTimer() {
//        mainCardTimer?.invalidate()
//        
//        mainCardTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
//            withAnimation {
//                currentMainCardIndex = (currentMainCardIndex + 1) % mainDisplayCards.count
//            }
//        }
//    }
//    
//   
//    func createServiceSection(
//        title: String,
//        description: String,
//        icon: String,
//        cards: [String]
//    ) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            
//            NavigationLink(destination: NINAuthFlow()) {
//                HStack(alignment: .top) {
//                    
//                    Image(icon)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 40, height: 40)
//                        .clipShape(RoundedRectangle(cornerRadius: 6))
//                    
//                    
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text(title)
//                            .customFont(.subheadline, fontSize: 16)
//                        
//                        Text(description)
//                            .customFont(.body, fontSize: 16)
//                            .foregroundColor(.textBlackSec)
//                            .padding(.top, 5)
//                    }
//                    
//                    Spacer()
//                    
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.gray)
//                }
//            }
//            .buttonStyle(PlainButtonStyle())
//            
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: cardSpacing) {
//                    ForEach(0..<cards.count, id: \.self) { index in
//                        NavigationLink(destination: PassportDetailsView(selectedID: cards[index])) {
//                            Image(cards[index])
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: cardWidth, height: 142)
//                                .cornerRadius(12)
//                        }
//                    }
//                }
//            }
//            .frame(height: 142)
//        }
//        .padding(12)
//        .cornerRadius(12)
//    }
//}
//
//
//struct HomeWallet_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeWallet()
//    }
//}
