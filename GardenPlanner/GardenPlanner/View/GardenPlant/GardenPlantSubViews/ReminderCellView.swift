//
//  ReminderCellView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 4/2/24.
//

import SwiftUI
import SwiftData

struct ReminderCellView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var showDeleteAlert = false
    
    @Query var gardenPlants: [YourPlant]
    
    @Binding var allReminders: [Reminder]
    
    var reminder: Reminder
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: GardenColors.plantGreen.rawValue))
            
            HStack {
                VStack(alignment: .leading) {
                    
//                    if reminder.ownerPlant.name != "" {
//                        Text(reminder.ownerPlant.name)
//                            .font(.title2)
//                            .fontWeight(.light)
//                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
//                    }
                    
                    Text(reminder.name)
                        .font(.title3)
                        .padding(reminder.ownerPlant.name == "" ? .top : .bottom, 0)
                    
                    if !reminder.subtitle.isEmpty {
                        Text(reminder.subtitle)
                    }
                    
                    HStack {
                        if !reminder.repeats {
                            Text(reminder.time.formatted(date: .abbreviated, time: .shortened))
                            
                        } else {
                            HStack {
                                Text("Repeating:")
                                Text("\(reminder.howOften.rawValue) at \(reminder.time.formatted(date: .omitted, time: .shortened))")
                            }
                        }
                        
                        if (reminder.time <= Date() && reminder.repeats == false) || reminder.ownerPlant.addedEntry {
                            
                            Image(systemName: "checkmark")
                                .font(.title3)
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    if !reminder.repeats && reminder.ownerPlant.name != "" {
                        Button {
                            for eachPlant in gardenPlants {
                                if eachPlant.id == reminder.ownerPlant.id {
                                    withAnimation(.smooth.delay(0.2)) {
                                    eachPlant.entrys.append(Entry(id: reminder.id, title: reminder.name, body: reminder.subtitle, date: reminder.time))
                                        reminder.ownerPlant.addedEntry = true
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(reminder.ownerPlant.addedEntry ? Color(hex: GardenColors.plantGreen.rawValue) : Color(hex: GardenColors.whiteSmoke.rawValue))
                                
                                HStack {
                                    Text(reminder.ownerPlant.addedEntry ? "Entry Added" : "Add Entry")
                                }
                                .foregroundStyle(reminder.ownerPlant.addedEntry ? Color(hex: GardenColors.whiteSmoke.rawValue) : Color(hex: GardenColors.plantGreen.rawValue))
                            }
                            .frame(width: 95, height: 40)
                            .shadow(radius: 1)
                        }
                        .padding(.horizontal)
                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.red)
                            
                            Image(systemName: "trash.fill")
                                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            
                        }
                        .frame(width: 40, height: 40)
                    }
                    .alert("Delete this Reminder?", isPresented: $showDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            withAnimation(.smooth) {
                                
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
                                
                                allReminders = allReminders.filter { remind in
                                    remind.id.uuidString == reminder.id.uuidString ? false : true
                                }
                                
                            }
                            print(allReminders, "on button press")
                            
                            UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
                                for request in requests {
                                    if let timeIntervalTrigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                                        print(Date(timeIntervalSinceNow: timeIntervalTrigger.timeInterval))
                                    }
                                    
                                    if request.trigger is UNCalendarNotificationTrigger {
                                        print("Request: \(request)")
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: YourPlant.self, configurations: config)
        
        return ReminderCellView(allReminders: .constant([]), reminder: Reminder(id: UUID(), name: "Something", subtitle: "Something else important", time: Date(), repeats: false, howOften: RepeatingNotifications.daily, ownerPlant: OwnerPlant(id: 0, name: "Apple", addedEntry: false)))
            .modelContainer(container)
        
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
