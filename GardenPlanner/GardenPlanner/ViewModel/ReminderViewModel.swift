//
//  ReminderViewModel.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 4/2/24.
//

import Foundation
import UserNotifications

class ReminderViewModel {
    
    static let shared = ReminderViewModel()
    
    func scheduleReminder(at date: Date, reminder: Reminder) {
        let newReminder = Reminder(id: reminder.id, name: reminder.name, subtitle: reminder.subtitle, time: reminder.time, repeats: reminder.repeats, howOften: reminder.howOften, ownerPlant: reminder.ownerPlant)
        
        let content = UNMutableNotificationContent()
        content.title = "\(newReminder.ownerPlant.name): \(newReminder.name)"
        content.body = newReminder.subtitle
        content.sound = UNNotificationSound.default
        
        var trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: false)
        
        if reminder.repeats {
            
            let dateComponents = reminder.howOften.dateComponents(for: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
        } else {
            
            let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        }
        
        let request = UNNotificationRequest(identifier: newReminder.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
//                DispatchQueue.main.async {
//                    append and save the new Reminder to the plant
//                }
            }
        }
    }
}
