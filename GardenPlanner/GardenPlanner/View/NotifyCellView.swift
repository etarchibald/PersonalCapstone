//
//  NotifyCellView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/8/24.
//

import SwiftUI

struct NotifyCellView: View {
    
    @StateObject private var notifyViewModel = NotifyViewModel()
    
    @Binding var allReminders: [Notify]
    
    @State private var showDeleteAlert = false
    
    var reminder: Notify
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: GardenColors.skyBlue.rawValue))
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .fill(Color(hex: GardenColors.whiteSmoke.rawValue))
                    
                    VStack {
                        Text(reminder.name)
                            .font(.title2)
                        
                        if !reminder.subtitle.isEmpty {
                            Text(reminder.subtitle)
                        }
                        
                        if !reminder.repeats {
                            Text(reminder.time.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                    .padding()
                }
                .padding()
                
                
                VStack {
                    
                    if reminder.repeats {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(hex: GardenColors.plantGreen.rawValue))
                            
                            Text(reminder.howOften.rawValue)
                                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            
                        }
                        .frame(width: 80, height: 50, alignment: .center)
                    }
                    
                    if reminder.time <= Date() && reminder.repeats == false {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.red)
                            
                            Text("Expired")
                                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            
                        }
                        .frame(width: 80, height: 50, alignment: .center)
                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.red)
                            
                            Image(systemName: "trash.fill")
                                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                .font(.title2)
                            
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                    }
                    .alert("Delete this Reminder?", isPresented: $showDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            withAnimation(.smooth) {
                                allReminders = allReminders.filter { remind in
                                    remind.id.uuidString == reminder.id.uuidString ? false : true
                                }
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
                                notifyViewModel.saveToFiles(allReminders)
                            }
                            print(allReminders, "on button press")
                            
                            UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
                                for request in requests {
                                    if let timeIntervalTrigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                                        print(Date(timeIntervalSinceNow: timeIntervalTrigger.timeInterval))
                                    }
                                    
                                    if request.trigger is UNCalendarNotificationTrigger {
                                        print(request)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .shadow(radius: 10)
    }
}

#Preview {
    NotifyCellView(allReminders: .constant([]), reminder: Notify(id: UUID(), name: "Water something very long and bad", subtitle: "Cherry Tree to do with a thing with another thing to make this string longer", time: Date(), repeats: true, howOften: RepeatingNotifications.week))
}
