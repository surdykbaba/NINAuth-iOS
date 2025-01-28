//
//  NINAuth_iOSApp.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 26/01/2025.
//

import SwiftUI
import RealmSwift

@main
struct NINAuth_iOSApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            Group {
                NavigationView {
                    SplashScreenView()
                }
                .navigationViewStyle(.stack)
                .tint(Color.green)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let config = Realm.Configuration(
                schemaVersion: 1, deleteRealmIfMigrationNeeded: false)
        Realm.Configuration.defaultConfiguration = config
        hideBackButtonText()
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        Log.info(uuid ?? "")
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
        //navigationBarAppearance.backgroundColor = UIColor(named: "bg_black")
        navigationBarAppearance.shadowColor = .clear
        // Title font color
//        navigationBarAppearance.titleTextAttributes = [
//                NSAttributedString.Key.foregroundColor: UIColor.white,
//                NSAttributedString.Key.font: UIFont(name: "FuturaPT-Medium", size: 20)!]
//        navigationBarAppearance.largeTitleTextAttributes = [
//                NSAttributedString.Key.foregroundColor: UIColor.white,
//                NSAttributedString.Key.font: UIFont(name: "FuturaPT-Medium", size: 22)!]

        //Not sure you'll need both of these, but feel free to adjust to your needs.
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }
    
}
