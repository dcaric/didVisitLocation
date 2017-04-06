//
//  NotificationLocal.swift
//  WorkHours3
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
        // NSNumber
        //content.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber + 1);
        //content.categoryIdentifier = ""
        // Deliver the notification in five seconds.
        /*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'time interval must be at least 60 if repeating'*/
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 15, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }

}
