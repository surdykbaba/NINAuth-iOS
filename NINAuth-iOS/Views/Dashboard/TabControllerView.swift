//
//  TabView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI

struct TabControllerView: View {
    @State var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    CustomTabItem(imageName: "home", title: "Home", isActive: selectedTab == 0)
                }
                .tag(0)

            DevicesView()
                .tabItem {
                    CustomTabItem(imageName: "consent", title: "Consent", isActive: selectedTab == 1)
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    CustomTabItem(imageName: "settings", title: "Settings", isActive: selectedTab == 2)
                }
                .tag(2)

        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
    }

    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        VStack {
            Image(isActive ? imageName : "\(imageName)_black")
                .resizable()
                .frame(width: 28, height: 28)
                .mask(
                    RoundedRectangle(cornerRadius: 20, style: .continuous))
            Text(title)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    TabControllerView()
}

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case consent
    case settings

    var title: String{
        switch self {
        case .home:
            return "Home"
        case .consent:
            return "Consent"
        case .settings:
            return "Settings"
        }
    }

    var iconName: String{
        switch self {
        case .home:
            return "home"
        case .consent:
            return "consent"
        case .settings:
            return "settings"
        }
    }
}
