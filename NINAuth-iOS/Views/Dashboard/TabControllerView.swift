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
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(.stack)
            .tag(0)
            .tint(Color(.greenText))
            .tabItem {
                CustomTabItem(imageName: "home", title: "Home", isActive: selectedTab == 0)
            }

            
            NavigationView {
                ConsentView()
            }
            .navigationViewStyle(.stack)
            .tag(1)
            .tint(Color(.greenText))
            .tabItem {
                CustomTabItem(imageName: "consent", title: "Consent", isActive: selectedTab == 1)
            }


            NavigationView {
                SettingsView()
            }
            .navigationViewStyle(.stack)
            .tag(2)
            .tint(Color(.greenText))
            .tabItem {
                CustomTabItem(imageName: "settings", title: "Settings", isActive: selectedTab == 2)
            }

        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
        .navigationBarBackButtonHidden()
    }

    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        VStack {
            Image(isActive ? imageName : "\(imageName)_black")
                .resizable()
                .frame(width: 32, height: 32)
                .mask(
                    RoundedRectangle(cornerRadius: 20, style: .continuous))
            Text(title)
                .foregroundColor(.black)
        }
        .padding(.vertical)
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
