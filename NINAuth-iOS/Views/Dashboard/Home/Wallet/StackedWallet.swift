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

// MARK: - WalletView
struct WalletView: View {
    @State private var cards: [Card] = [
        Card(imageName: "card1"),
        Card(imageName: "card2"),
        Card( imageName: "card3"),
        Card( imageName: "card4"),
        Card( imageName: "card6"),
        Card( imageName: "card7"),
        
    ]
    
    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragging = false
    @State private var navigateToNINAuthFlow = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title & Description
            Text("My Wallet")
                .customFont(.title, fontSize: 17)
                .padding(.horizontal)

            Text("Add your IDs to NINAuth Wallet")
                .customFont(.subheadline, fontSize: 17)
                .foregroundColor(.text)
                .padding(.horizontal)
                .padding(.bottom,10)

            // Card Stack
            ZStack {
                ForEach(cards.indices, id: \.self) { index in
                    let isTopCard = index == 0
                    let peekOffset: CGFloat = CGFloat(index) * -12
                    let frontCardOffset: CGFloat = 10

                    CardView(card: cards[index])
                        .scaleEffect(1 - CGFloat(index) * 0.05)
                        .offset(y: isTopCard ? (dragOffset.height + frontCardOffset) : peekOffset)
                        .zIndex(Double(cards.count - index))
                        .gesture(
                            isTopCard ?
                            DragGesture()
                                .updating($isDragging) { value, state, _ in
                                    state = true
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    if abs(value.translation.height) > 50 {
                                        withAnimation(.spring()) {
                                            let removed = cards.removeFirst()
                                            cards.append(removed)
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
                        .animation(.spring(), value: cards)
                }
            }
            .frame(height: 260)
            .padding(.horizontal)
            

            // Info Box
            HStack(alignment: .top) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 8, height: 8)
                    .padding(.top, 6)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Tap the card to view your next ID. Use your digital IDs for quick verification and access to services anytime.")
                        .customFont(.body, fontSize: 16)
                        .padding(.bottom,10)

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
            }
            .padding()
            .background(Color(.grayBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top, 30)
            

            Spacer()
                
            
            NavigationLink(destination: NINAuthFlow(), isActive: $navigateToNINAuthFlow) {
                    EmptyView()
                    }

                                // Add Button
                Button(action: {
                navigateToNINAuthFlow = true
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
            .padding(.bottom, 20)
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
                .frame(height: 210)
                .clipped()
                .cornerRadius(16)
                .shadow(radius: 5)
        }
        .frame(height: 200)
    }
}


#Preview {
    WalletView()
}
