//  StackedWallet.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 13/05/2025.

import SwiftUI

struct WalletApp: App {
    var body: some Scene {
        WindowGroup {
            WalletView()
        }
    }
}

struct WalletView: View {
    @State private var selectedCard: Int? = nil
    @State private var showDetails: Bool = false
    @State private var showWallet = false
    @State private var cardOrder: [Int] = [0, 1, 2, 3] // Using indices for card order
    @State private var showQRView: Bool = false
    @State private var showInfoBox: Bool = true // State to control info box visibility
    
    // Simplified card data - just using indices
    var cards: [Int] {
        return cardOrder
    }
    
    // Multiple card images
    let cardImages = ["card1", "card2", "card3", "card4"]
    
    // Card colors for visual distinction (can be removed if actual images are used)
    let cardColors: [Color] = [.red, Color(red: 0.4, green: 0.7, blue: 0.9),
                              Color(red: 0.2, green: 0.4, blue: 0.9),
                              Color(red: 0, green: 0.5, blue: 0.4)]
    
    var body: some View {
        
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            // Main wallet view
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.button)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Text("My Wallet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 5)
                
                Text("Add your IDs to NINAuth Wallet")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                
                // Stacked cards - aligned straight
                ZStack {
                    ForEach(cards.indices, id: \.self) { index in
                        StraightStackedCardView(
                            cardImage: cardImages[cards[index] % cardImages.count],
                            cardColor: cardColors[cards[index]],
                            index: index,
                            totalCards: cards.count,
                            onTap: { cardIndex in
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    selectedCard = cards[cardIndex]
                                    showQRView = true
                                }
                            },
                            onDragEnd: { cardIndex, _ in
                                moveCardToBack(cardIndex: index)
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .frame(height: 400) // Adjust based on your needs
                
                Spacer()
                
                // Info box at bottom - with dismissal functionality
                if showInfoBox {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 8, height: 8)
                                .padding(.top, 6)
                            
                            Text("Tap the card to view your next ID. Use your digital IDs for quick verification and access to services anytime.")
                                .foregroundColor(.black)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showInfoBox = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        HStack {
                            Text("Learn more about NINAuth wallet")
                                .foregroundColor(.button)
                                .font(.subheadline)
                                .offset(x:20)
                            
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.button)
                                .offset(x:15)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
                    .padding(.bottom,50)
                    .padding()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .onAppear {
                        // Auto-dismiss after 4 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                            withAnimation(.easeInOut(duration: 0.10)) {
                                showInfoBox = false
                            }
                        }
                    }
                }
            }
            
            // Slide-up QR view
            if showQRView, let selectedCardIndex = selectedCard {
                QRDetailView(
                    selectedCardIndex: selectedCardIndex,
                    cardImages: cardImages,
                    cardColors: cardColors,
                    cards: cards,
                    showDetails: $showDetails,
                    onClose: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showQRView = false
                            selectedCard = nil
                        }
                    },
                    onCardTap: { cardIndex in
                        withAnimation(.spring()) {
                            selectedCard = cardIndex
                        }
                    }
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
    }
    
    // Function to move a card to the back of the stack
    private func moveCardToBack(cardIndex: Int) {
        withAnimation(.spring()) {
            let card = cardOrder.remove(at: cardIndex)
            cardOrder.append(card) // Move to the end (back of the stack)
        }
    }
}

// Separate QR Detail View that slides up
struct QRDetailView: View {
    let selectedCardIndex: Int
    let cardImages: [String]
    let cardColors: [Color]
    let cards: [Int]
    @Binding var showDetails: Bool
    let onClose: () -> Void
    let onCardTap: (Int) -> Void
    
    var body: some View {
        ScrollView{
            VStack(spacing: 0) {
                // Header with close button
                HStack {
//                    Button(action: onClose) {
//                        Image(systemName: "xmark")
//                            .font(.title2)
//                            .foregroundColor(.black)
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: {}) {
//                        Image(systemName: "ellipsis")
//                            .font(.title2)
//                            .foregroundColor(.black)
//                            .padding()
//                    }
                }
//                .padding(.horizontal)
                
                
                // Card detail container
                VStack(spacing: 20) {
                    // Selected card - using specific dimensions
                    ZStack {
                        // Using cardColors as a fallback if images aren't available
                        // Rectangle()
                        //     .fill(cardColors[selectedCardIndex])
                        //     .frame(width: 286, height: 186)
                        //     .cornerRadius(16)
                        
                        // Actual card image would replace this
                        Image(cardImages[selectedCardIndex % cardImages.count])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 306, height: 186)
                            .cornerRadius(16)
                            .clipped()
                            .padding(.top,10)
                    }
                    
                    // QR Code
                    Image("QR code image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                        .foregroundColor(.black)
                    
                    // Document Details section with button below
                    VStack(spacing: 15) {
                        // Only show the "Show Document Details" button if details are hidden
                        if !showDetails {
                            Button(action: {
                                withAnimation {
                                    showDetails.toggle()
                                }
                            }) {
                                Text("Show Document Details")
                                    .foregroundColor(.button)
                                    .font(.headline)
                                    .underline()
                                    .padding(.bottom, 10)

                            }
                        }
                        
                        // Document Details
                        if showDetails {
                            VStack(alignment: .center, spacing: 15) {
                                // Background container with fixed width
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Allow organizations scan the QR code to securely access your digital document.")
                                        .font(.subheadline)
                                        .padding(.bottom, 5)
                                    
                                    Group {
                                        DetailRow(label: "Date of Issue", value: "27/06/2024")
                                        DetailRow(label: "Date of Expiry", value: "27/06/2024")
                                        DetailRow(label: "Issuer", value: "Nigerian Immigration Service")
                                        DetailRow(label: "Wallet ID", value: "FCT, Abuja")
                                    }
                                }
                                .padding()
                                .frame(width: 358)
                                .background(Color(hex: "#F6F8F6"))
                                .cornerRadius(12)
                                .transition(.opacity.combined(with: .scale))
                                
                                // Button outside the background
                                Button(action: {
                                    withAnimation {
                                        showDetails.toggle()
                                    }
                                }) {
                                    Text("Hide Document Details")
                                        .foregroundColor(.button)
                                        .underline()
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.bottom, 10)
                                }
                                .padding(.top, 10)
                            }
                            .frame(maxWidth: .infinity) // Centers the VStack horizontally

                        }
                    }
                }
                .padding(.horizontal)
//                .background(
//                    Color.white
//                        .cornerRadius(20)
////                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
//                )
                .padding(.horizontal)

                
                Spacer()
                
                // Stacked cards at bottom - outside border background
                ZStack {
                    ForEach(cards.filter { $0 != selectedCardIndex }.reversed(), id: \.self) { index in
                        ZStack {
                            // Using cardColors as a fallback
                            Rectangle()
                                .fill(cardColors[index])
                                .frame(width: 390, height: 240)
                                .cornerRadius(12)
                            
                            // Actual card image would replace this
                            Image(cardImages[index % cardImages.count])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 390, height: 240)
                                .cornerRadius(12)
                                .clipped()
                        }
                        .offset(y: CGFloat(cards.firstIndex(of: index) ?? 0) * -55)
                        .zIndex(Double(-(cards.firstIndex(of: index) ?? 0)))
                        .onTapGesture {
                            onCardTap(index)
                        }
                    }
                }
                .frame(height: 280)
                .padding(.horizontal)
                .padding(.top,200)
                
            }
            .background(Color(hex: "#FFFFFF"))
            .ignoresSafeArea()
        }
    }
}

// Straight stacked card view for the main wallet screen
struct StraightStackedCardView: View {
    let cardImage: String
    let cardColor: Color
    let index: Int
    let totalCards: Int
    let onTap: (Int) -> Void
    let onDragEnd: (Int, CGFloat) -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    // Calculate vertical position in stack - cards are aligned straight
    private var verticalOffset: CGFloat {
        return CGFloat(index) * -40 // Larger offset for clear visibility
    }
    
    var body: some View {
        ZStack {
            // Actual card image would replace this
            Image(cardImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 390, height: 242)
                .cornerRadius(16)
                .clipped()
                .padding(.top, 120)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .offset(y: verticalOffset + dragOffset)
        .opacity(isDragging ? 0.8 : 1.0)
        .zIndex(Double(totalCards - index)) // Higher cards have higher z-index
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    let translation = value.translation.height
                    dragOffset = translation
                }
                .onEnded { value in
                    isDragging = false
                    let translation = value.translation.height
                    let threshold: CGFloat = 60
                    
                    withAnimation(.spring()) {
                        if abs(translation) > threshold {
                            // If dragged significantly, move to back
                            onDragEnd(index, translation)
                        }
                        dragOffset = 0
                    }
                }
        )
        .onTapGesture {
            if !isDragging {
                onTap(index)
            }
        }
    }
}

// Detail row for document details
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

// Preview
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
