//
//  AppDelegate.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/7/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .badge, .sound])
        
        print("\(notification.request.identifier): \(notification.date.description)")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        return true
    }
}
