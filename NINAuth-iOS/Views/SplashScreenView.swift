//
//  SplashScreen.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 26/01/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @State var showLoginScreen: Bool = false

    var body: some View {
        VStack {
            if self.showLoginScreen {
                OnboardingView()
            } else {
                Spacer()
                Image("AppFullLogo")
                    .frame(width: 157, height: 41)
                Spacer()
                Text("powered_by_nimc")
                    .customFont(.headline, fontSize: 17)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showLoginScreen = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
