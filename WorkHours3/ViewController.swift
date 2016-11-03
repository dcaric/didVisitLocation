//
//  ViewController.swift
//  WorkHours3
//
//  Created by Dario Caric on 29/10/2016.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

import UIKit
import  UserNotifications

@available(iOS 10.0, *)
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let center = UNUserNotificationCenter.current()
        
        // create actions
        let accept = UNNotificationAction.init(identifier: "com.elonchan.yes",
                                               title: "Accept",
                                               options: UNNotificationActionOptions.foreground)
        let decline = UNNotificationAction.init(identifier: "com.elonchan.no",
                                                title: "Decline",
                                                options: UNNotificationActionOptions.destructive)
        let snooze = UNNotificationAction.init(identifier: "com.elonchan.snooze", title: "Snooze", options: UNNotificationActionOptions.destructive)
        let actions = [ accept, decline, snooze ]
        
        // create a category
        let inviteCategory = UNNotificationCategory(identifier: "com.elonchan.localNotification", actions: actions, intentIdentifiers: [], options: [])
        // registration
        center.setNotificationCategories([ inviteCategory ])
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print ("viewWillAppear")
        
        let myNotifObj = NotificationLocal()
        myNotifObj.triggerNotification(title: "INFO:", body: "This is fo for testing only ..")
    }
    

}

