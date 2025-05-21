//
//  StackedWallet.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 13/05/2025.
//

import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
}

struct WalletView: View {
    @State private var cards: [Card] = [
        Card(imageName: "card1"),
        Card(imageName: "card2"),
        Card(imageName: "card3"),
        Card(imageName: "card4"),
        Card(imageName: "card6"),
        Card(imageName: "card7")
    ]
    
    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragging = false
    
    @State private var navigateToPassport = false
    @State private var navigateToHomeWallet = false
    @State private var showInfoSection = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("My Wallet")
                .customFont(.title, fontSize: 24)
                .padding(.horizontal)
                .padding(.top,60)
            
            Text("Add your IDs to NINAuth Wallet")
                .customFont(.subheadline, fontSize: 17)
                .foregroundColor(.text)
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            ZStack {
                ForEach(cards.indices, id: \.self) { index in
                    let isFirstCard = index == 0
                    let stackSpacing: CGFloat = CGFloat(index) * -12
                    let frontCardOffset: CGFloat = 10
                    
                    CardView(card: cards[index])
                        .scaleEffect(1 - CGFloat(index) * 0.05)
                        .offset(y: isFirstCard ? (dragOffset.height + frontCardOffset) : stackSpacing)
                        .zIndex(Double(cards.count - index))
                        .gesture(
                            isFirstCard ? DragGesture()
                                .updating($isDragging) { value, state, _ in
                                    state = true
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    if abs(value.translation.height) > 50 {
                                        withAnimation(.spring()) {
                                            let removedCard = cards.removeFirst()
                                            cards.append(removedCard)
                                            dragOffset = .zero
                                        }
                                    } else {
                                        withAnimation {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                            : nil
                        )
                        .onTapGesture {
                            if isFirstCard {
                                navigateToPassport = true
                            }
                        }
                        .animation(.spring(), value: cards)
                }
            }
            .frame(height: 280)
            .padding(.horizontal)
            
            if showInfoSection {
                HStack(alignment: .top) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Tap the card to view your next ID. Use your digital IDs for quick verification and access to services anytime.")
                            .customFont(.body, fontSize: 15)
                            .padding(.bottom, 10)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 4) {
                            Link(destination: URL(string: "https://ninauth.com")!) {
                                HStack(spacing: 4) {
                                    Text("Learn more about NINAuth wallet")
                                        .font(.subheadline)
                                        .foregroundColor(.button)
                                        .underline()
                                    
                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundColor(.button)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showInfoSection = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(8)
                            .clipShape(Circle())
                    }
                }
                .padding()
                .background(Color(.grayBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 30)
                .transition(.opacity)
            }
            
            Spacer()
            
            NavigationLink(destination: PassportView(), isActive: $navigateToPassport) {
                EmptyView()
            }
            
            NavigationLink(destination: HomeWallet(), isActive: $navigateToHomeWallet) {
                EmptyView()
            }
            
            Button(action: {
                navigateToHomeWallet = true
            }) {
                Text("Add new ID")
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.button)
                    .cornerRadius(4)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
}
struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            Image(card.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 360, height: 220)
                .clipped()
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) //
        }
        .frame(width: 350, height: 240)
    }
}
#Preview {
    NavigationView {
        WalletView()
    }
}
