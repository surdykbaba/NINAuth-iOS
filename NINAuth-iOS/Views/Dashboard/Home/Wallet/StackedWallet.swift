
//
//  EmptyWallet.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 12/05/2025.


import SwiftUI


struct WalletView: View {
    @State private var selectedCard: Int? = nil
    @State private var showCardDetails: Bool = false
    
    @State private var showQRView: Bool = false
    @State private var showAddNewCard = false
    @State private var showInfoBanner = true
    @State private var showMenu = false
    @State private var cardOrder: [Int] = [0, 1, 2,3,4]
    
    let cardNames = [
        "Immigration11",
        "travel card",
        "Inec",
        "creditcorp",
       "Drive 1",
    ]
    
    var body: some View {
        ZStack {
            backgroundView
            mainContentView
            floatingAddButton
            menuOverlay
            qrCodeOverlay
        }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showMenu.toggle()
                            }
                        }) {
//                            Image(systemName: "")
//                                .font(.system(size: 18, weight: .semibold))
//                                .foregroundColor(.primary)
//                                .frame(width: 36, height: 36)
//                                .background(Color(.systemGray6))
//                                .clipShape(Circle())
                        }
                    }
                }
                .sheet(isPresented: $showAddNewCard) {
                    AddToWalletView()
                }
            
        
        
        .navigationBarHidden(false)
        .sheet(isPresented: $showAddNewCard) {
            AddToWalletView()
        }
    }
    
    //  Background View
    private var backgroundView: some View {
        Color(.systemBackground).ignoresSafeArea()
    }
    
    //  Main Content View
    private var mainContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            infoBannerSection
            cardsSection
            Spacer()
        }
    }
    
    // Header Section
    private var headerSection: some View {
        HStack {
            titleSection
            Spacer()
            menuButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Wallet")
                .customFont(.headline, fontSize: 24)
                .padding(.horizontal,10)
                
                
            Text("Add your IDs to wallet")
                .customFont(.body, fontSize: 16)
                .padding(.horizontal,10)
                
        }
    }
    
    private var menuButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showMenu.toggle()
            }
        }) {
            
        }
    }
    
    //  Info Banner Section
    @ViewBuilder
    private var infoBannerSection: some View {
        if showInfoBanner {
            HStack(alignment: .top) {
                bannerIndicator
                bannerText
                Spacer()
                bannerCloseButton
            }
            .padding(20)
            .background(Color(hex: "ECEFEC"))
//            .background(Color(.#ECEFEC))
            .cornerRadius(12)
            .padding(.horizontal, 25)
            .padding(.top, 30)
            .transition(.opacity.combined(with: .scale))
        }
    }
    
    private var bannerIndicator: some View {
        Circle()
            .fill(Color.primary)
            .frame(width: 6, height: 6)
            .padding(.top, 8)
    }
    
    private var bannerText: some View {
        Text("Tap the card to view your next ID. Use your digital IDs for quick verification and access to services anytime.")
            .customFont(.body, fontSize: 16)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
    }
    
    private var bannerCloseButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                showInfoBanner = false
            }
        }) {
            Image(systemName: "xmark")
                .customFont(.headline, fontSize: 16)
                .foregroundColor(.primary)
        }
    }
    
  
    // Cards Section
    private var cardsSection: some View {
        ZStack(alignment: .center) { // Center alignment for the ZStack
            ForEach(cardOrder.indices, id: \.self) { position in
                SingleCardView(
                    cardImageName: cardNames[cardOrder[position]],
                    positionInStack: position,
                    totalCards: cardOrder.count,
                    isCurrentlySelected: selectedCard == cardOrder[position],
                    whenTapped: { cardIndex in
                        handleCardTap(cardIndex: cardIndex)
                    },
                    whenDragEnds: { _, _ in } // Disable drag
                )
                .id("\(cardOrder[position])_\(position)_\(showQRView)") // Force refresh
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, showInfoBanner ? 40 : 70)
        .frame(height: 300)
        .padding(.top, 60)
    }

    
    //  Floating Add Button
    private var floatingAddButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showAddNewCard = true
                }) {
                    Image(systemName: "plus")
                        .customFont(.headline, fontSize: 24)
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.button)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                
            }
        }
    }
    
    //  Menu Overlay
    @ViewBuilder
    private var menuOverlay: some View {
        if showMenu {
            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    menuContent
                }
                Spacer()
            }
            .background(menuBackground)
            .transition(.opacity.combined(with: .scale))
            .zIndex(10)
        }
    }
    
    private var menuContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            cashbackOption
            Divider()
            deleteOption
        }
        .padding(12)
        .frame(width: 180)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.trailing, 12)
        .padding(.top, 12)
    }
    
    private var cashbackOption: some View {
        HStack(spacing: 6) {
            Image(systemName: "wallet.pass")
            Text("Cash back Rewards")
                .foregroundColor(.black)
                .font(.system(size: 14, ))
        }
    }
    
    private var deleteOption: some View {
        HStack(spacing: 6) {
            Image(systemName: "trash")
                .foregroundColor(.red)
            Text("Delete ID")
                .foregroundColor(.red)
                .customFont(.headline, fontSize: 24)
        }
    }
    
    private var menuBackground: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    showMenu = false
                }
            }
    }
    
    //  QR Code Overlay (FULL SCREEN WITH HIDDEN NAVIGATION)
    @ViewBuilder
    private var qrCodeOverlay: some View {
        if showQRView, let selectedCardIndex = selectedCard {
            // Full screen overlay that covers navigation bar
            ZStack {
                CardDetailView(
                    selectedCardIndex: selectedCardIndex,
                    allCardNames: cardNames,
                    allCards: cardOrder,
                    showDetails: $showCardDetails,
                    onClose: {
                        resetCardStates()
                    },
                    onCardTap: { cardIndex in
                        handleCardTapInDetail(cardIndex: cardIndex)
                    },
                    onRemoveID: { cardIndex in
                        handleRemoveID(cardIndex: cardIndex)
                    }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea(.all) // This ensures it covers the navigation bar
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .zIndex(1000) // Highest z-index for full screen
        }
    }
    
    // Helper Functions
    private func handleCardTap(cardIndex: Int) {
        withAnimation(.spring()) {
            selectedCard = cardOrder[cardIndex]
            showQRView = true
            
            let vibration = UIImpactFeedbackGenerator(style: .medium)
            vibration.impactOccurred()
        }
    }
    
    private func handleCardTapInDetail(cardIndex: Int) {
        withAnimation(.spring()) {
            selectedCard = cardIndex
            
            let vibration = UIImpactFeedbackGenerator(style: .medium)
            vibration.impactOccurred()
        }
    }
    
    private func resetCardStates() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedCard = nil
            showQRView = false
            showCardDetails = false
        }
    }
    
    private func moveCardToBack(cardPosition: Int) {
        withAnimation(.spring()) {
            let card = cardOrder.remove(at: cardPosition)
            cardOrder.append(card)
            
            let vibration = UIImpactFeedbackGenerator(style: .light)
            vibration.impactOccurred()
        }
    }
    
    // Remove ID Handler
    private func handleRemoveID(cardIndex: Int) {
        // Remove the card from the order array
        if let indexToRemove = cardOrder.firstIndex(of: cardIndex) {
            withAnimation(.spring()) {
                cardOrder.remove(at: indexToRemove)
            }
        }
        
        // Close the detail view
        resetCardStates()
        
        // Add haptic feedback
        let vibration = UIImpactFeedbackGenerator(style: .medium)
        vibration.impactOccurred()
    }
}
// Single Card Component (Updated for width alignment)
struct SingleCardView: View {
    let cardImageName: String
    let positionInStack: Int
    let totalCards: Int
    let isCurrentlySelected: Bool
    let whenTapped: (Int) -> Void
    let whenDragEnds: (Int, CGFloat) -> Void
    
    @State private var dragDistance: CGFloat = 0
    @State private var isDragging = false
    
    private var verticalPosition: CGFloat {
        if isCurrentlySelected {
            return -200
        } else {
            return CGFloat(positionInStack) * -55
        }
    }
    
    var body: some View {
        cardImage
            .offset(x: 0, y: verticalPosition + dragDistance)
            .scaleEffect(cardScale)
            .zIndex(cardZIndex)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isCurrentlySelected)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: positionInStack)
            .gesture(dragGesture)
            .onTapGesture {
                handleTap()
            }
    }
    
    private var cardImage: some View {
        Image(cardImageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 220)
            .frame(maxWidth: .infinity) // All cards use same width as container
            .clipped()
            .padding(.top, 230)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // Maintain consistent width while preserving visual depth
    private var cardScale: CGFloat {
        if isCurrentlySelected {
            return 1.05
        } else {
            // Keep all non-selected cards at the same scale for width consistency
            // Only the selected card scales up for emphasis
            return 1.0
        }
    }
    
    private var cardZIndex: Double {
        isCurrentlySelected ? 100 : Double(totalCards - positionInStack)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { dragValue in
                if !isCurrentlySelected {
                    isDragging = true
                    dragDistance = dragValue.translation.height
                }
            }
            .onEnded { dragValue in
                if !isCurrentlySelected {
                    handleDragEnd(dragValue: dragValue)
                }
            }
    }
    
    private func handleTap() {
        if !isDragging && !isCurrentlySelected {
            whenTapped(positionInStack)
        }
    }
    
    private func handleDragEnd(dragValue: DragGesture.Value) {
        isDragging = false
        let dragAmount = dragValue.translation.height
        let minimumDragDistance: CGFloat = 60
        
        withAnimation(.spring()) {
            if abs(dragAmount) > minimumDragDistance {
                whenDragEnds(positionInStack, dragAmount)
            }
            dragDistance = 0
        }
    }
}

// Perfect Width Alignment Version - All cards use identical spacing and width
struct SingleCardViewPerfectAlignment: View {
    let cardImageName: String
    let positionInStack: Int
    let totalCards: Int
    let isCurrentlySelected: Bool
    let whenTapped: (Int) -> Void
    let whenDragEnds: (Int, CGFloat) -> Void
    
    @State private var dragDistance: CGFloat = 0
    @State private var isDragging = false
    
    private var verticalPosition: CGFloat {
        if isCurrentlySelected {
            return -200
        } else {
            return CGFloat(positionInStack) * -55
        }
    }
    
    var body: some View {
        cardImage
            .offset(x: 0, y: verticalPosition + dragDistance)
            .scaleEffect(cardScale)
            .zIndex(cardZIndex)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isCurrentlySelected)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: positionInStack)
            .gesture(dragGesture)
            .onTapGesture {
                handleTap()
            }
    }
    
    private var cardImage: some View {
        Image(cardImageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 220)
            .frame(maxWidth: .infinity) // All cards inherit the container's width constraints
            .clipped()
            .padding(.top, 190)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // All cards maintain same scale except selected card
    private var cardScale: CGFloat {
        isCurrentlySelected ? 1.05 : 1.0
    }
    
    private var cardZIndex: Double {
        isCurrentlySelected ? 100 : Double(totalCards - positionInStack)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { dragValue in
                if !isCurrentlySelected {
                    isDragging = true
                    dragDistance = dragValue.translation.height
                }
            }
            .onEnded { dragValue in
                if !isCurrentlySelected {
                    handleDragEnd(dragValue: dragValue)
                }
            }
    }
    
    private func handleTap() {
        if !isDragging && !isCurrentlySelected {
            whenTapped(positionInStack)
        }
    }
    
    private func handleDragEnd(dragValue: DragGesture.Value) {
        isDragging = false
        let dragAmount = dragValue.translation.height
        let minimumDragDistance: CGFloat = 60
        
        withAnimation(.spring()) {
            if abs(dragAmount) > minimumDragDistance {
                whenDragEnds(positionInStack, dragAmount)
            }
            dragDistance = 0
        }
    }
}

struct SingleCardViewAlternative: View {
    let cardImageName: String
    let positionInStack: Int
    let totalCards: Int
    let isCurrentlySelected: Bool
    let whenTapped: (Int) -> Void
    let whenDragEnds: (Int, CGFloat) -> Void
    
    @State private var dragDistance: CGFloat = 0
    @State private var isDragging = false
    
    private var verticalPosition: CGFloat {
        if isCurrentlySelected {
            return -200
        } else {
            return CGFloat(positionInStack) * -55
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            cardImage(width: geometry.size.width)
                .offset(x: 0, y: verticalPosition + dragDistance)
                .scaleEffect(cardScale)
                .zIndex(cardZIndex)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isCurrentlySelected)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: positionInStack)
                .gesture(dragGesture)
                .onTapGesture {
                    handleTap()
                }
        }
    }
    
    private func cardImage(width: CGFloat) -> some View {
        Image(cardImageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width - 40, height: 220) // Fixed width based on container
            .clipped()
            .padding(.top, 190)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // Minimal scaling to preserve width alignment
    private var cardScale: CGFloat {
        if isCurrentlySelected {
            return 1.05
        } else {
            // Very minimal scaling that won't affect width noticeably
            return 1.0 - CGFloat(positionInStack) * 0.005
        }
    }
    
    private var cardZIndex: Double {
        isCurrentlySelected ? 100 : Double(totalCards - positionInStack)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { dragValue in
                if !isCurrentlySelected {
                    isDragging = true
                    dragDistance = dragValue.translation.height
                }
            }
            .onEnded { dragValue in
                if !isCurrentlySelected {
                    handleDragEnd(dragValue: dragValue)
                }
            }
    }
    
    private func handleTap() {
        if !isDragging && !isCurrentlySelected {
            whenTapped(positionInStack)
        }
    }
    
    private func handleDragEnd(dragValue: DragGesture.Value) {
        isDragging = false
        let dragAmount = dragValue.translation.height
        let minimumDragDistance: CGFloat = 60
        
        withAnimation(.spring()) {
            if abs(dragAmount) > minimumDragDistance {
                whenDragEnds(positionInStack, dragAmount)
            }
            dragDistance = 0
        }
    }
}


//- Preview
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
