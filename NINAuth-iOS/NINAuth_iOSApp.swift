//
//  NINAuth_iOSApp.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 26/01/2025.
//

import SwiftUI
import RealmSwift
import SmileID

@main
struct NINAuth_iOSApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
            }
            .navigationViewStyle(.stack)
            .tint(Color.button)
            .environmentObject(appState)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let config = Realm.Configuration(
                schemaVersion: 2, deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        hideBackButtonText()
        SmileID.initialize(useSandbox: true)
        SmileID.setCallbackUrl(url: URL(string: "https://smileidentity.com"))
        return true
    }
    
    func hideBackButtonText() {
        let navigationBarAppearance = UINavigationBarAppearance()

        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
    
        navigationBarAppearance.backButtonAppearance = backButtonAppearance
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.backgroundImage = UIImage()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.shadowColor = .clear
        // Title font color
        navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(named: "text")!,
                NSAttributedString.Key.font: UIFont(name: "PlusJakartaSans-Medium", size: 20)!]
        navigationBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "text")!,
                NSAttributedString.Key.font: UIFont(name: "PlusJakartaSans-Medium", size: 24)!]
        

        //Not sure you'll need both of these, but feel free to adjust to your needs.
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }
    
}
