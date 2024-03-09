//
//  ContentView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct NotificationsView: View {
    
    @StateObject var notifyViewModel = NotifyViewModel()
    
    @State var allReminders = [Notify]()
    
    @State var reminder = Notify(id: UUID(), name: "", subtitle: "", time: Date(), repeats: false, howOften: RepeatingNotifications.week)
    
    @State var showMessage = false
    @State var showErrorMessage = false
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(hex: GardenColors.skyBlue.rawValue))
                
                VStack {
                    TextField("Title", text: $reminder.name)
                        .padding()
                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                        .clipShape(RoundedRectangle(cornerRadius: 20 ))
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    
                    TextField("Message", text: $reminder.subtitle)
                        .padding()
                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                        .clipShape(RoundedRectangle(cornerRadius: 20 ))
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                    
                    DatePicker("When:", selection: $reminder.time)
                        .padding()
                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                        .clipShape(RoundedRectangle(cornerRadius: 20 ))
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                    
                    Toggle("Repeat", isOn: $reminder.repeats)
                        .padding()
                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                        .clipShape(RoundedRectangle(cornerRadius: 20 ))
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                    
                    if reminder.repeats {
                        Picker("How often:", selection: $reminder.howOften) {
                            ForEach(RepeatingNotifications.allCases, id: \.self) { value in
                                Text(value.rawValue)
                                    .tag(value)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.trailing)
                        .padding()
                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                    }
                    
                    HStack {
                        
                        Button {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    showMessage = true
                                } else if error != nil {
                                    showErrorMessage = true
                                }
                            }
                        } label: {
                            Text("Request Permission")
                                .padding()
                                .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                        }
                        .alert("You're all set!", isPresented: $showMessage) {
                            Button("Thank you", role: .none) { }
                        }
                        .alert("You need to allow Notifications", isPresented: $showErrorMessage) {
                            Button("Thank you", role: .none) { }
                        }
                        
                        Button {
                            guard !reminder.name.isEmpty, reminder.time == Date() else { return }
                            
                            if reminder.repeats {
                                if reminder.howOften.rawValue == "Week" {
                                    if let fireDate = Calendar.current.date(byAdding: .day, value: 7, to: reminder.time) {
                                        scheduleRepeatingNotification(time: fireDate, repeatingComponent: .day)
                                    }
                                } else if reminder.howOften.rawValue == "Month" {
                                    if let fireDate = Calendar.current.date(byAdding: .month, value: 1, to: reminder.time) {
                                        scheduleRepeatingNotification(time: fireDate, repeatingComponent: .month)
                                    }
                                } else if reminder.howOften.rawValue == "Year" {
                                    if let fireDate = Calendar.current.date(byAdding: .year, value: 1, to: reminder.time) {
                                        scheduleRepeatingNotification(time: fireDate, repeatingComponent: .year)
                                    }
                                }
                            } else {
                                scheduleSingleNotification(time: reminder.time)
                            }
                            
                            UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
                                for request in requests {
                                    if let timeIntervalTrigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                                        print(Date(timeIntervalSinceNow: timeIntervalTrigger.timeInterval))
                                    }

                                }
                            }
                            
                        } label: {
                            Text("Add Reminder")
                                .padding()
                                .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                        }
                    }
                    Spacer()
                }
            }
            .frame(width: 380, height: 300, alignment: .center)
            .padding(EdgeInsets(top: 30, leading: 0, bottom: 50, trailing: 0))
            
            ScrollView {
                VStack {
                    ForEach(allReminders, id: \.self) { remind in
                        NotifyCellView(allReminders: $allReminders, reminder: remind)
                    }
                }
            }
        }
        .onAppear(perform: {
            allReminders = notifyViewModel.loadFromFiles()
            allReminders = allReminders.filter { $0.time >= Date() && !$0.repeats }
            print(allReminders, "onAppear")
        })
    }
}

#Preview {
    NotificationsView()
}

extension NotificationsView {
    
    func scheduleRepeatingNotification(time: Date, repeatingComponent: Calendar.Component) {
        
        let content = UNMutableNotificationContent()
        content.title = reminder.name
        content.subtitle = reminder.subtitle
        content.sound = UNNotificationSound.default
        
        if let firstRepeatingDate = Calendar.current.date(byAdding: repeatingComponent, value: 1, to: time) {
            let repeatingTrigger = UNTimeIntervalNotificationTrigger(timeInterval: firstRepeatingDate.timeIntervalSinceNow, repeats: true)
            let repeatingRequest = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: repeatingTrigger)
            
            UNUserNotificationCenter.current().add(repeatingRequest) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Successfully scheduled")
                    DispatchQueue.main.async {
                        allReminders.append(reminder)
                        notifyViewModel.saveToFiles(allReminders)
                    }
                }
            }
        }
    }
    
    func scheduleSingleNotification(time: Date) {
        let content = UNMutableNotificationContent()
        content.title = reminder.name
        content.subtitle = reminder.subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Seccessfully scheduled")
                DispatchQueue.main.async {
                    allReminders.append(reminder)
                    notifyViewModel.saveToFiles(allReminders)
                    print(allReminders)
                }
            }
        }
    }
}
