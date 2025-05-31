//
//  WalletID.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 20/05/2025.
//

import SwiftUI
import PassKit


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
    
    // Apple Wallet states
    @State private var showAppleWalletSuccess = false
    @State private var isAddingToWallet = false
    @State private var showAppleWalletError = false
    @State private var walletErrorMessage = ""
    
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
                
                if showAppleWalletSuccess {
                    // Apple Wallet success overlay
                    appleWalletSuccessOverlay
                } else if showAppleWalletError {
                    // Apple Wallet error overlay
                    appleWalletErrorOverlay
                } else if showRemoveSuccess {
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
            .gesture(showRemoveSuccess || showRemoveConfirmation || showAppleWalletSuccess || showAppleWalletError ? nil : improvedDragToCloseGesture)
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
    
    
    private var appleWalletSuccessOverlay: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 30) {
                // Apple Wallet icon
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "wallet.pass")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(showAppleWalletSuccess ? 1.0 : 0.5)
                .opacity(showAppleWalletSuccess ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showAppleWalletSuccess)
                
                VStack(spacing: 12) {
                    Text("Added to Apple Wallet")
                        .customFont(.headline, fontSize: 24)
                        .foregroundColor(.primary)
                        .opacity(showAppleWalletSuccess ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(0.5), value: showAppleWalletSuccess)
                    
                    Text("Your ID is now available in Apple Wallet for quick access")
                        .customFont(.body, fontSize: 16)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .opacity(showAppleWalletSuccess ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(0.7), value: showAppleWalletSuccess)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(Color.white)
        .onAppear {
            // Auto-close after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showAppleWalletSuccess = false
                }
            }
        }
    }
    
   
    private var appleWalletErrorOverlay: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showAppleWalletError = false
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 24) {
                    // Error icon
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.red)
                    }
                    .scaleEffect(showAppleWalletError ? 1.0 : 0.8)
                    .opacity(showAppleWalletError ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showAppleWalletError)
                    
                    VStack(spacing: 12) {
                        Text("Unable to Add to Wallet")
                            .customFont(.headline, fontSize: 20)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text(walletErrorMessage)
                            .customFont(.body, fontSize: 16)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    .opacity(showAppleWalletError ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.4).delay(0.2), value: showAppleWalletError)
                    
                    // Close button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAppleWalletError = false
                        }
                    }) {
                        Text("Close")
                            .customFont(.headline, fontSize: 16)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.button)
                            .cornerRadius(8)
                    }
                    .opacity(showAppleWalletError ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.4).delay(0.3), value: showAppleWalletError)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 32)
                .scaleEffect(showAppleWalletError ? 1.0 : 0.9)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showAppleWalletError)
                
                Spacer()
            }
        }
    }
    
    
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
            // Auto-close after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    onClose()
                }
            }
        }
    }
    
   
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
    
   
    private var detailScrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                selectedCardSection
                    .padding(.top, 20)
                
                qrCodeSection
                    .padding(.top, 30)
                
                documentDetailsSection
                    .padding(.top, 20)
                
                // Add to Apple Wallet button - moved up by 20 points
                appleWalletButtonSection
                    .padding(.top, 10)
                
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
            Image("qrcode")
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
    
   
    private var appleWalletButtonSection: some View {
        VStack(spacing: 10) {
            // Divider line
//            Rectangle()
//                .fill(Color.gray.opacity(0.3))
//                .frame(height: 1)
//                .padding(.horizontal, 25)
            
            // Centered Apple Wallet button with reduced width
            HStack {
                Spacer()
                
                Button(action: {
                    addToAppleWallet()
                }) {
                    HStack(spacing: 12) {
                        if isAddingToWallet {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            // Official Apple Wallet icon with colored cards
                            ZStack {
                                // Card stack with colors
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.white)
                                    .frame(width: 28, height: 20)
                                
                                VStack(spacing: 0) {
                                    // Top card - green/teal
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(Color(red: 0.2, green: 0.8, blue: 0.6))
                                        .frame(width: 24, height: 3)
                                        .offset(y: -1)
                                    
                                    // Middle card - orange/yellow
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(Color(red: 1.0, green: 0.7, blue: 0.2))
                                        .frame(width: 24, height: 3)
                                    
                                    // Bottom card - red/pink
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(Color(red: 1.0, green: 0.4, blue: 0.4))
                                        .frame(width: 24, height: 3)
                                        .offset(y: 1)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Add to")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white)
                            Text("Apple Wallet")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(width: 200, height: 50) // Fixed width of 200 instead of full width
                    .background(Color.black)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .disabled(isAddingToWallet)
                .opacity(isAddingToWallet ? 0.7 : 1.0)
                .scaleEffect(isAddingToWallet ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isAddingToWallet)
                
                
                Spacer()
            }
        }
    }
    
    private var bottomSpacer: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 120)
    }
    
    
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
    
   
    private func addToAppleWallet() {
        guard !isAddingToWallet else { return }
        
        // Check if PassKit is available
        guard PKAddPassesViewController.canAddPasses() else {
            walletErrorMessage = "Apple Wallet is not available on this device."
            withAnimation(.easeInOut(duration: 0.3)) {
                showAppleWalletError = true
            }
            return
        }
        
        isAddingToWallet = true
        
        // Add haptic feedback
        let vibration = UIImpactFeedbackGenerator(style: .light)
        vibration.impactOccurred()
        
        // Simulate API call that results in unauthorized error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            simulateAddToWalletError(message: "Unauthorized request. Please check your credentials and try again.")
        }
    }
    
    private func simulateAddToWalletSuccess() {
        isAddingToWallet = false
        
        // Add success haptic feedback
        let vibration = UINotificationFeedbackGenerator()
        vibration.notificationOccurred(.success)
        
        // Show success overlay
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showAppleWalletSuccess = true
        }
    }
    
    private func simulateAddToWalletError(message: String) {
        isAddingToWallet = false
        walletErrorMessage = message
        
        // Add error haptic feedback
        let vibration = UINotificationFeedbackGenerator()
        vibration.notificationOccurred(.error)
        
        // Show error overlay
        withAnimation(.easeInOut(duration: 0.3)) {
            showAppleWalletError = true
        }
    }
    
   
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
