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
                schemaVersion: 1, deleteRealmIfMigrationNeeded: false)
        Realm.Configuration.defaultConfiguration = config
        hideBackButtonText()
        let configss = getConfig()
        try? Log.info("The sending json body \(configss.jsonPrettyPrinted())")
        
        SmileID.initialize(config: configss, useSandbox: true)
        SmileID.setCallbackUrl(url: URL(string: "https://smileidentity.com"))
        return true
    }
    
    public func getConfig(from resourceName: String = "smile_config") -> Config {
        let decoder = JSONDecoder()
        let configUrl = Bundle.main.url(forResource: resourceName, withExtension: "json")!
        // swiftlint:disable force_try
        return try! decoder.decode(Config.self, from: Data(contentsOf: configUrl))
        // swiftlint:enable force_try
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
