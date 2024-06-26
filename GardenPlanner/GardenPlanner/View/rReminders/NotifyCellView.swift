//
//  NotifyCellView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/8/24.
//

import SwiftUI
import SwiftData

struct NotifyCellView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var allReminders: [Reminder]
    
    @State private var showDeleteAlert = false
    
    @Query var gardenPlants: [YourPlant]
    
    @Binding var reminder: Reminder
    
    var body: some View {
        
        //preview doesn't look right but it looks better in the app
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: GardenColors.skyBlue.rawValue))
                .shadow(radius: 10)
            
            VStack {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .fill(colorScheme == .light ? Color(hex: GardenColors.whiteSmoke.rawValue) : Color(hex: GardenColors.richBlack.rawValue))
                    
                    VStack {
//                        VStack {
//                            if reminder.ownerPlant.name != "" {
//                                Text(reminder.ownerPlant.name)
//                                    .font(.title2)
//                                    .fontWeight(.light)
//                                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
//                                    .padding()
//                                    .background(Color(hex: GardenColors.skyBlue.rawValue))
//                                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 20, topTrailing: 0)))
//                            }
//                        }
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        VStack {
                            Text(reminder.name)
                                .font(.title2)
                                .padding(reminder.ownerPlant.name == "" ? .top : .bottom, 0)
                            
                            if !reminder.subtitle.isEmpty {
                                Text(reminder.subtitle)
                            }
                            
                            if !reminder.repeats {
                                Text(reminder.time.formatted(date: .abbreviated, time: .shortened))
                                
                            } else {
                                HStack {
                                    Text("Repeating:")
                                    Text("\(reminder.howOften.rawValue) at \(reminder.time.formatted(date: .omitted, time: .shortened))")
                                }
                            }
                        }
                        
                        HStack {
                            
                            if (reminder.time <= Date() && reminder.repeats == false) || reminder.ownerPlant.addedEntry {
                                
                                Text("Complete")
                                    .padding(10)
                                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .background(Color(hex: GardenColors.plantGreen.rawValue))
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            }
                            
                            if !reminder.repeats && reminder.ownerPlant.name != "" {
                                Button {
                                    for eachPlant in gardenPlants {
                                        if eachPlant.id == reminder.ownerPlant.id {
                                            eachPlant.entrys.append(Entry(id: reminder.id, title: reminder.name, body: reminder.subtitle, date: reminder.time))
                                            withAnimation(.smooth.delay(0.2)) {
                                                reminder.ownerPlant.addedEntry = true
                                            }
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(reminder.ownerPlant.addedEntry ? Color(hex: GardenColors.whiteSmoke.rawValue) : Color(hex: GardenColors.skyBlue.rawValue))
                                        
                                        HStack {
                                            Text(reminder.ownerPlant.addedEntry ? "Entry Added" : "Add Entry")
                                        }
                                        .foregroundStyle(reminder.ownerPlant.addedEntry ? Color(hex: GardenColors.skyBlue.rawValue) : Color(hex: GardenColors.whiteSmoke.rawValue))
                                    }
                                    .frame(width: 85, height: 40)
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
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
            }
            .padding(.vertical)
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

//#Preview {
//    NotifyCellView(allReminders: .constant([]), reminder: .constant(Reminder(id: UUID(), name: "Water something very long and bad", subtitle: "Cherry Tree to do with a thing with another thing to make this string longer", time: Date(), repeats: false, howOften: RepeatingNotifications.week, ownerPlant: OwnerPlant(id: 0, name: "Apple", addedEntry: false))))
//}
