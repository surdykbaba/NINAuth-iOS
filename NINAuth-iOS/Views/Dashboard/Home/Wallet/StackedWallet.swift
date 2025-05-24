import SwiftUI

// MARK: - Main Wallet Screen
struct WalletView: View {
    @State private var selectedCard: Int? = nil
    @State private var showCardDetails: Bool = false
    
    @State private var showQRView: Bool = false
    @State private var showAddNewCard = false
    @State private var showInfoBanner = true
    @State private var showMenu = false
    @State private var cardOrder: [Int] = [0, 1, 2, 3]
    
    let cardNames = [
        "immigration1",
        "cowry1",
        "firstbank",
        "gym1"
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
            
        
        // Keep navigation bar for WalletView
        .navigationBarHidden(false)
        .sheet(isPresented: $showAddNewCard) {
            AddToWalletView()
        }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        Color(.systemBackground).ignoresSafeArea()
    }
    
    // MARK: - Main Content View
    private var mainContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            infoBannerSection
            cardsSection
            Spacer()
        }
    }
    
    // MARK: - Header Section
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
    
    // MARK: - Info Banner Section
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
    
    // MARK: - Cards Section
    private var cardsSection: some View {
        ZStack {
            ForEach(cardOrder.indices, id: \.self) { position in
                SingleCardView(
                    cardImageName: cardNames[cardOrder[position]],
                    positionInStack: position,
                    totalCards: cardOrder.count,
                    isCurrentlySelected: selectedCard == cardOrder[position],
                    whenTapped: { cardIndex in
                        handleCardTap(cardIndex: cardIndex)
                    },
                    whenDragEnds: { cardIndex, _ in
                        moveCardToBack(cardPosition: position)
                    }
                )
                .id("\(cardOrder[position])_\(position)_\(showQRView)") // Force refresh
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, showInfoBanner ? 40 : 70)
        .frame(height: 300)
    }
    
    // MARK: - Floating Add Button
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
                .padding(.bottom, 20)
            }
        }
    }
    
    // MARK: - Menu Overlay
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
    
    // MARK: - QR Code Overlay (FULL SCREEN WITH HIDDEN NAVIGATION)
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
    
    // MARK: - Helper Functions
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
    
    // MARK: - Remove ID Handler
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

// MARK: - Single Card Component
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
            return CGFloat(positionInStack) * -45
        }
    }
    
    var body: some View {
        cardImage
            .offset(y: verticalPosition + dragDistance)
            .opacity(isDragging ? 0.8 : 1.0)
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
            .clipped()
            .padding(.top, 190)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var cardScale: CGFloat {
        isCurrentlySelected ? 1.05 : (1.0 - CGFloat(positionInStack) * 0.02)
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

// MARK: - Card Detail View (FULL SCREEN WITH NO NAVIGATION BAR)
struct CardDetailView: View {
    let selectedCardIndex: Int
    let allCardNames: [String]
    let allCards: [Int]
    @Binding var showDetails: Bool
    let onClose: () -> Void
    let onCardTap: (Int) -> Void
    let onRemoveID: (Int) -> Void
    
    @State private var dragDistance: CGFloat = 0
    @State private var cardScale: CGFloat = 1.0
    @State private var cardOpacity: Double = 1.0
    @GestureState private var isDragging = false
    @State private var showMenu = false
    @State private var showRemoveSuccess = false
    @State private var isRemoving = false
    @State private var showRemoveConfirmation = false
    
    // Reset states when view appears
    private func resetViewStates() {
        dragDistance = 0
        cardScale = 1.0
        cardOpacity = 1.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full screen background that covers everything including navigation bar
                Color.white
                    .ignoresSafeArea(.all)
                
                if showRemoveSuccess {
                    // Success overlay
                    removeSuccessOverlay
                } else if showRemoveConfirmation {
                    // Confirmation dialog overlay
                    removeConfirmationOverlay
                } else {
                    VStack(spacing: 0) {
                        // Custom header that replaces navigation bar (removed close button)
                        detailHeaderSection(geometry: geometry)
                        
                        // Scrollable content
                        detailScrollContent
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    detailMenuOverlay
                }
            }
            .gesture(showRemoveSuccess || showRemoveConfirmation ? nil : improvedDragToCloseGesture)
        }
        .ignoresSafeArea(.all, edges: .all)
        .navigationBarHidden(true)
        .onAppear {
            resetViewStates()
        }
        .onDisappear {
            resetViewStates()
        }
    }
    
    // MARK: - Remove Confirmation Overlay
    private var removeConfirmationOverlay: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    // Close dialog when tapping outside
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showRemoveConfirmation = false
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Dialog container
                VStack(spacing: 24) {
                    // Warning icon
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.red)
                    }
                    .scaleEffect(showRemoveConfirmation ? 1.0 : 0.8)
                    .opacity(showRemoveConfirmation ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showRemoveConfirmation)
                    
                    VStack(spacing: 12) {
                        Text("Remove Card from Wallet?")
                            .customFont(.headline, fontSize: 20)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("This action cannot be undone. You'll need to add the Card again if you want to use it in the future.")
                            .customFont(.body, fontSize: 16)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    .opacity(showRemoveConfirmation ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.4).delay(0.2), value: showRemoveConfirmation)
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        // Remove button
                        Button(action: {
                            confirmRemoveID()
                        }) {
                            Text("Remove ID")
                                .customFont(.headline, fontSize: 16)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .disabled(isRemoving)
                        .opacity(isRemoving ? 0.6 : 1.0)
                        
                        // Cancel button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showRemoveConfirmation = false
                            }
                        }) {
                            Text("Cancel")
                                .customFont(.headline, fontSize: 16)
                                .foregroundColor(Color.button)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.button, lineWidth: 1.5)
                                )
                                .cornerRadius(8)
                        }
                    }
                    .opacity(showRemoveConfirmation ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.4).delay(0.3), value: showRemoveConfirmation)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 32)
                .scaleEffect(showRemoveConfirmation ? 1.0 : 0.9)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showRemoveConfirmation)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Remove Success Overlay
    private var removeSuccessOverlay: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 30) {
                // Success checkmark
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(showRemoveSuccess ? 1.0 : 0.5)
                .opacity(showRemoveSuccess ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showRemoveSuccess)
                
                VStack(spacing: 12) {
                    Text("ID Removed Successfully")
                        .customFont(.headline, fontSize: 24)
                        .foregroundColor(.primary)
                        .opacity(showRemoveSuccess ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(0.5), value: showRemoveSuccess)
                    
                    Text("Your ID has been removed from the wallet")
                        .customFont(.body, fontSize: 16)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .opacity(showRemoveSuccess ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(0.7), value: showRemoveSuccess)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(Color.white)
        .onAppear {
            // Auto-close after 10 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    onClose()
                }
            }
        }
    }
    
    // MARK: - Detail Header Section (REMOVED CLOSE BUTTON)
    private func detailHeaderSection(geometry: GeometryProxy) -> some View {
        HStack {
            Spacer() // Center the menu button
//            detailMenuButton
        }
        .padding(.horizontal, 20)
        .padding(.top, max(geometry.safeAreaInsets.top + 10, 54))
        .padding(.bottom, 15)
        .background(Color.white)
        .zIndex(10)
    }
    
//    private var detailMenuButton: some View {
//        Button(action: {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                showMenu.toggle()
//            }
//        }) {
//            Image(systemName: "")
//                .font(.system(size: 18, weight: .semibold))
//                .foregroundColor(.primary)
//                .frame(width: 36, height: 36)
//                .background(Color(.systemGray6))
//                .clipShape(Circle())
//        }
//    }
    
    // MARK: - Detail Scroll Content
    private var detailScrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                selectedCardSection
                    .padding(.top, 20)
                
                qrCodeSection
                    .padding(.top, 30)
                
                documentDetailsSection
                    .padding(.top, 20)
                
                bottomSpacer
            }
            .offset(y: dragDistance)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
        }
    }
    
    private var selectedCardSection: some View {
        VStack(spacing: 25) {
            ZStack {
                Image(allCardNames[selectedCardIndex % allCardNames.count])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 360, height: 230)
                    .cornerRadius(9)
                    .clipped()
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
            }
        }
    }
    
    private var qrCodeSection: some View {
        VStack(spacing: 20) {
            Image("QR code image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 220, height: 220)
                .foregroundColor(.black)
                .padding(15)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    private var documentDetailsSection: some View {
        VStack(spacing: 25) {
            if !showDetails {
                showDetailsButton
            }
            
            if showDetails {
                detailsContent
                hideDetailsButton
            }
        }
        .padding(.horizontal, 25)
    }
    
    private var showDetailsButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                showDetails.toggle()
            }
        }) {
            HStack(spacing: 8) {
                Text("Show Document Details")
                    .foregroundColor(.button)
                    .underline()
                    .customFont(.headline, fontSize: 17)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .padding(.bottom, 20)
            .cornerRadius(30)
        }
    }
    
    // MARK: - Updated details content section (move details up by 10)
    private var detailsContent: some View {
        VStack(alignment: .center, spacing: 15) { // Reduced from 25 to 15
            VStack(alignment: .leading, spacing: 15) { // Reduced from 25 to 15
                Text("Allow organizations scan the QR code to securely access your digital document.")
                    .customFont(.body, fontSize: 16)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                VStack(spacing: 10) { // Reduced from 20 to 10 to move details up
                    DetailRow(title: "Date of Issue", info: "27/06/2024")
                    DetailRow(title: "Date of Expiry", info: "27/06/2029")
                    DetailRow(title: "Issuer", info: "Nigerian Immigration Service")
                    DetailRow(title: "Wallet ID", info: "NISNW65570028")
                    
                    // Remove ID button
                    HStack {
                        Spacer()
                        Button(action: {
                            handleRemoveIDTap()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "trash")
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                                Text("Remove ID")
                                    .customFont(.body, fontSize: 14)
                                    .foregroundColor(.red)
                            }
                        }
                        .disabled(isRemoving)
                        .opacity(isRemoving ? 0.6 : 1.0)
                    }
                    .padding(.top, 5)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.96, green: 0.97, blue: 0.96))
            .cornerRadius(20)
            .transition(.opacity.combined(with: .scale))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var hideDetailsButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                showDetails.toggle()
            }
        }) {
            HStack(spacing: 8) {
                Text("Hide Document Details")
                    .foregroundColor(.button)
                    .underline()
                    .customFont(.headline, fontSize: 17)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
        }
    }
    
    private var bottomSpacer: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 120)
    }
    
    // MARK: - Detail Menu Overlay
    @ViewBuilder
    private var detailMenuOverlay: some View {
        if showMenu {
            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    detailMenuContent
                }
                Spacer()
            }
            .background(detailMenuBackground)
            .transition(.opacity.combined(with: .scale))
            .zIndex(20)
        }
    }
    
    private var detailMenuContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
                Text("Delete ID")
                    .foregroundColor(.red)
                    .customFont(.subheadline, fontSize: 10)
            }
        }
        .padding(16)
        .frame(width: 190)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.trailing, 25)
        
    }
    
    private var detailMenuBackground: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    showMenu = false
                }
            }
    }
    
    // MARK: - Remove ID Handler
    private func handleRemoveIDTap() {
        guard !isRemoving else { return }
        
        // Show confirmation dialog
        withAnimation(.easeInOut(duration: 0.3)) {
            showRemoveConfirmation = true
        }
        
        // Add haptic feedback
        let vibration = UIImpactFeedbackGenerator(style: .light)
        vibration.impactOccurred()
    }
    
    // MARK: - Confirm Remove ID
    private func confirmRemoveID() {
        guard !isRemoving else { return }
        
        isRemoving = true
        
        // Add haptic feedback
        let vibration = UIImpactFeedbackGenerator(style: .medium)
        vibration.impactOccurred()
        
        // Hide confirmation dialog and show success screen
        withAnimation(.easeInOut(duration: 0.3)) {
            showRemoveConfirmation = false
        }
        
        // Small delay before showing success screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showRemoveSuccess = true
            }
        }
        
        // Call the remove function to update the parent
        onRemoveID(selectedCardIndex)
    }
    
    // MARK: - Improved Drag to Close Gesture
    private var improvedDragToCloseGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { value, state, _ in
                state = true
            }
            .onChanged { value in
                let translation = value.translation.height
                
                if translation > 0 {
                    // Only allow downward dragging
                    let progress = min(translation / 200, 1.0) // Normalize to 0-1
                    let dampingFactor: CGFloat = 0.6
                    
                    // Apply damped drag distance
                    dragDistance = translation * dampingFactor
                    
                    // Scale and opacity effects based on drag progress
                    let scaleReduction = progress * 0.1 // Scale down by up to 10%
                    cardScale = max(0.9, 1.0 - scaleReduction) // Prevent going too small
                    
                    let opacityReduction = progress * 0.3 // Fade by up to 30%
                    cardOpacity = max(0.7, 1.0 - opacityReduction) // Prevent going too transparent
                }
            }
            .onEnded { value in
                let translation = value.translation.height
                let velocity = value.velocity.height
                
                // Enhanced threshold calculation considering both distance and velocity
                let shouldClose = translation > 120 || (translation > 80 && velocity > 800)
                
                if shouldClose {
                    // Trigger haptic feedback
                    let vibration = UIImpactFeedbackGenerator(style: .medium)
                    vibration.impactOccurred()
                    
                    // Animate out of view completely
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        dragDistance = UIScreen.main.bounds.height + 100 // Move completely off screen
                        cardScale = 0.7
                        cardOpacity = 0
                    }
                    
                    // Call onClose immediately, but reset states after
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        onClose()
                        // Reset states after closing for next time
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            resetViewStates()
                        }
                    }
                } else {
                    // Reset to original position with spring animation
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        resetViewStates()
                    }
                }
            }
    }
}

// MARK: - Detail Row Component (with reduced spacing)
struct DetailRow: View {
    let title: String
    let info: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) { // Reduced from 2 to 1
                Text(title)
                    .customFont(.body, fontSize: 13)
                    .foregroundColor(.secondary)
                
                Text(info)
                    .customFont(.subheadline, fontSize: 16)
                    .foregroundColor(.primary)
                    .padding(.bottom, 2) // Reduced from 10 to 5
            }
            
            Spacer()
        }
        .padding(.vertical, 6) // Reduced from 10 to 8
    }
}


// MARK: - Preview
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
