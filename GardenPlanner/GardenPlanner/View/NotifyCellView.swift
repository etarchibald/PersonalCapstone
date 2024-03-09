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
    
    var reminder: Notify
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: GardenColors.skyBlue.rawValue))
            
            HStack {
                VStack {
                    Text(reminder.name)
                    
                    if !reminder.subtitle.isEmpty {
                        Text(reminder.subtitle)
                    }
                    
                    Text(reminder.time.formatted(date: .abbreviated, time: .shortened))
                    
                    Text(reminder.repeats ? "Repeats" : "")
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30))
                
                
                Button {
                    allReminders = allReminders.filter { remind in
                        remind.id.uuidString == reminder.id.uuidString ? false : true
                    }
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
                    notifyViewModel.saveToFiles(allReminders)
                    print(allReminders, "on button press")
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.red)
                        
                        Image(systemName: "trash.fill")
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                        
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                
            }
            
        }
        .frame(width: 350, height: 120, alignment: .center)
    }
}

#Preview {
    NotifyCellView(allReminders: .constant([]), reminder: Notify(id: UUID(), name: "Water", subtitle: "Cherry Tree", time: Date(), repeats: true, howOften: RepeatingNotifications.week))
}
