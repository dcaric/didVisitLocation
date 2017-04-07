//
//  NotificationLocal.swift
//  CheckOutIn
//
//  Created by Dario Caric on 30/10/2016.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

import Foundation
import  UserNotifications

@available(iOS 10.0, *)
class NotificationLocal: NSObject {
    
    func triggerNotification (title: String, body: String) -> Void {
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 15, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }

}
