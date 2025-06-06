//
//  NINAuth_iOSApp.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 26/01/2025.
//

import SwiftUI
import RealmSwift
import SmileID
import Firebase
import FirebaseMessaging
import IQKeyboardManagerSwift

@main
struct NINAuth_iOSApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var appState = AppState()
    @State private var workItem: DispatchWorkItem?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
                    .id(appState.main)
            }
            .navigationViewStyle(.stack)
            .tint(Color.button)
            .environmentObject(appState)
            .hideWithScreenshot()
            .environment(\.dynamicTypeSize, .medium)
            .onChange(of: scenePhase) { newValue in
                switch newValue {
                case .background:
                    runForceLogout()
                case .inactive:
                    runForceLogout()
                default:
                    cancelTask()
                }
            }
        }
    }
    
    private func runForceLogout() {
        let mem = MemoryUtil()
        let res = mem.getBoolValue(key: mem.lock_app)
        if res {
            cancelTask()
            workItem = DispatchWorkItem {
                appState.userReferesh = true
                appState.main =  UUID()
            }
            
            if let item = workItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: item)
            }
        }
    }
    
    private func cancelTask() {
        workItem?.cancel()
        workItem = nil
    }
}

extension UIApplication {
    static func swizzlePreferredContentSizeCategory() {
        let originalSelector = #selector(getter: UIApplication.preferredContentSizeCategory)
        let swizzledSelector = #selector(UIApplication.swizzled_preferredContentSizeCategory)
        
        guard let originalMethod = class_getInstanceMethod(UIApplication.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIApplication.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc func swizzled_preferredContentSizeCategory() -> UIContentSizeCategory {
        return .medium // Replace with your desired fixed category
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        
        let config = Realm.Configuration(
                schemaVersion: 3, deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        hideBackButtonText()
        SmileID.initialize(useSandbox: false)
        SmileID.setCallbackUrl(url: URL(string: "https://smileidentity.com"))
        SmileID.apply(CustomTheme())
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        UIApplication.swizzlePreferredContentSizeCategory()
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        return true
    }
    
    // Add this method to override content size category changes
    func application(_ application: UIApplication, willChangeToContentSizeCategory newCategory: UIContentSizeCategory) {
        // Optionally, you can log when changes occur
        print("Content size category change detected: \(newCategory)")
        
        // Force the app to use a specific content size category
        NotificationCenter.default.post(name: UIContentSizeCategory.didChangeNotification, object: nil, userInfo: [UIContentSizeCategory.newValueUserInfoKey: UIContentSizeCategory.medium])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Log.info("willPresent")
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler([[.list, .banner, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Log.info("didReceive response")
       // let userInfo = response.notification.request.content.userInfo
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Log.info("The token on fresh launch \(deviceToken)")
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        if !token.isEmpty {
            //TODO: Do whatever you want to do with token
        }
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.error(error.localizedDescription)
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
        navigationBarAppearance.backgroundColor = .ninWhite
        navigationBarAppearance.shadowColor = .clear
        // Title font color
        navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(named: "text")!,
                NSAttributedString.Key.font: UIFont(name: "PlusJakartaSans-Medium", size: 20)!]
        navigationBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "text")!,
                NSAttributedString.Key.font: UIFont(name: "PlusJakartaSans-Medium", size: 24)!]
        // set back image
        navigationBarAppearance.setBackIndicatorImage(UIImage(named: "back_button"), transitionMaskImage: UIImage(named: "back_button"))

        

        //Not sure you'll need both of these, but feel free to adjust to your needs.
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let tokenDict = ["token": fcmToken ?? ""]
        Log.info(fcmToken ?? "")
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: tokenDict)
        if let token = fcmToken {
            let linkedIDService = LinkedIDService()
            Task {
                await linkedIDService.sendDeviceToken(deviceToken: DeviceToken(token: token))
            }
        }
    }
}

class CustomTheme: SmileIdTheme {
    var accent: Color {
        Color(hex: "#008643")
    }
}
