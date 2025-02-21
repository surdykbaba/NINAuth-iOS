//
//  SplashScreen.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 26/01/2025.
//

import SwiftUI
import RealmSwift

struct SplashScreenView: View {
    @State private var showLoginScreen: Bool = false
    @ObservedResults(User.self) var user
    @State private var showOnboarding: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Image("AppFullLogo")
                .frame(width: 157, height: 41)
            Spacer()
            Text("powered_by_nimc")
                .customFont(.headline, fontSize: 17)
            Group {
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $showLoginScreen){}.isDetailLink(false)
                NavigationLink(destination: OnboardingView().navigationBarBackButtonHidden(true), isActive: $showOnboarding){}.isDetailLink(false)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    if let _ = user.first {
                        showLoginScreen.toggle()
                    }else {
                        showOnboarding.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
