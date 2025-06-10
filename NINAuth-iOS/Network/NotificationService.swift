//
//  NotificationService.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 10/06/2025.
//

import Foundation
import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

class NotificationService: NSObject, MessagingDelegate {
    
    private var trials = 0
    
    //1. Singleton Class
    private override init() {
        super.init()
        let mem = MemoryUtil()
        let lastKey = mem.getStringValue(key: mem.notification_push_key)
        if(lastKey == nil || lastKey == "") {
            Messaging.messaging().delegate = self
            let data = mem.getDataValue(key: mem.apn_data)
            Messaging.messaging().apnsToken = data
        }
    }
    static let sharedInstance = NotificationService()
    
    //2. Get the current UNUserNotificationCenter
    let UNCurrentCenter = UNUserNotificationCenter.current()
    
    //3. Request the user authorization to send alerts.
    func authorizeNotification() {
        //3.1. Setting up the options the way you want to interact with the user.
        let options:UNAuthorizationOptions = [.alert, .badge, .sound]

        //3.2. Requests authorization with the user to deliver notification.
        UNCurrentCenter.requestAuthorization(options: options) { (granted, error) in
            Log.warning(error?.localizedDescription ?? "No UNAuthorization error")

            //3.3. completionHandler falls after the user's choice(maybe or maynot be granted).
            guard granted else {
                Log.error("User Denied the permission to receive Push")
                return
            }
            
            if let token = Messaging.messaging().fcmToken {
                Log.info("The token from saved \(token)")
            }
        }
    }
    
    func requestTimerNotification(repeatedly: Bool = false, title: String, subTitle: String, withinterval interval:TimeInterval, notificatioID: String) {
        
        //Specifies the payload for a local notification
        let content      = UNMutableNotificationContent()
        content.title    = title
        content.subtitle = subTitle
        content.sound = UNNotificationSound.default
        
        //Setup Time Interval Trigger to notify after the time interval, and optionally repeat
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeatedly)
        
        //Setup request to schedule a local notification
        let request = UNNotificationRequest(identifier: notificatioID,
                                            content: content,
                                            trigger: trigger)
        //Remove the pending request if needed
        self.removePendingNotifications(notificatioID)
        
        //Add the request to the current UNUserNotificationCenter
        self.UNCurrentCenter.add(request)
    }
    
    private func removePendingNotifications(_ requestIdentifier:String) {
        guard requestIdentifier != "" else { return }
        UNCurrentCenter.getPendingNotificationRequests(completionHandler: { [unowned self] requests in
            let pendingTimerRequests = requests.filter { return $0.identifier == requestIdentifier }.map{ $0.identifier }
            self.UNCurrentCenter.removePendingNotificationRequests(withIdentifiers: pendingTimerRequests)
        })
    }
    
    private func sendToken(msg: String) -> Bool {
        let mem = MemoryUtil()
        let lastMsg = mem.getStringValue(key: mem.notification_push_key)
        if(lastMsg == msg) {
            return false
        }
        mem.setValue(key: mem.notification_push_key, value: msg)
        return true
    }
    
    func removeAllPendingNotifications() {
        self.UNCurrentCenter.removeAllPendingNotificationRequests()
    }
    
    func subscribe(to topic: String) {
      Messaging.messaging().subscribe(toTopic: topic)
    }

    func unsubscribe(from topic: String) {
      Messaging.messaging().unsubscribe(fromTopic: topic)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let tokenDict = ["token": fcmToken ?? ""]
        Log.info(fcmToken ?? "")
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: tokenDict)
        if let token = fcmToken {
            if(sendToken(msg: token)) {
                sendTokenToServer(token: token)
            }else {
                Log.info("Token already sent")
            }
        }
    }
    
    private func sendTokenToServer(token: String) {
        let mem = MemoryUtil()
        let linkedIDService = LinkedIDService()
        Task {
            let res = await linkedIDService.sendDeviceToken(deviceToken: DeviceToken(token: token))
            switch res {
            case .success(let success):
                mem.setValue(key: mem.notification_push_key, value: token)
                Log.info("Sent ID succesful")
            case .failure(let failure):
                Log.error(failure.description)
                mem.setValue(key: mem.notification_push_key, value: "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [self] in
                    if(trials < 7) {
                        trials += 1
                        sendTokenToServer(token: token)
                    }
                }
            }
        }
    }
}

