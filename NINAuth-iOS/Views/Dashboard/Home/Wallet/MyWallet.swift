//
//  MyWallet.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 13/05/2025.
//



import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let imageName: String
}

// MARK: - WalletView
struct WalletView: View {
    @State private var cards: [Card] = [
        Card(title: "International Passport", imageName: "International passport"),
        Card(title: "Driver's License", imageName: "Drivers"),
        Card(title: "Driver's License", imageName: "voters"),
        Card(title: "International Passport", imageName: "resident"),
        
    ]
    
    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragging = false
    @State private var navigateToIDSelection = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title & Description
            Text("My Wallet")
                .font(.title)
                .bold()
                .padding(.horizontal)

            Text("Add your government issued IDs to NINAuth Wallet")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)

            // Card Stack
            ZStack {
                ForEach(cards.indices, id: \.self) { index in
                    let isTopCard = index == 0
                    let peekOffset: CGFloat = CGFloat(index) * -12
                    let frontCardOffset: CGFloat = 40

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
                    .frame(width: 6, height: 6)
                    .padding(.top, 6)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Tap the card to view your next ID. Use your digital IDs for quick verification and access to services anytime.")
                        .font(.subheadline)

                    Link("Learn more about NINAuth wallet", destination: URL(string: "https://ninauth.com")!)
                        .font(.subheadline)
                        .foregroundColor(.button)
                }
            }
            .padding()
            .background(Color(.gray))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top, 30)
            

            Spacer()
                
            
            NavigationLink(destination: IDSelectionScreen(), isActive: $navigateToIDSelection) {
                    EmptyView()
                    }

                                // Add Button
                Button(action: {
                navigateToIDSelection = true
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
