//
//  ContentView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import SwiftUI
import SwiftData
import UserNotifications
import Vortex

struct NotificationsView: View {
    @Environment(\.modelContext) var modelContext
    
    @StateObject var plantsViewModel = PlantsViewModel()
    
    @Query var gardenPlants: [YourPlant]
    
    @State var allReminders = [Reminder]()
    
    @State var reminder = Reminder(id: UUID(), name: "", subtitle: "", time: Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date(), repeats: false, howOften: RepeatingNotifications.daily, ownerPlant: OwnerPlant(id: 0, name: "", addedEntry: false))
    
    @State private var showMessage = false
    
    @State private var addReminder = false
    
    var body: some View {
        ZStack {
            VortexView(.customSlowRain) {
                Circle()
                    .fill(.white)
                    .frame(width: 32)
                    .tag("circle")
            }
            .ignoresSafeArea(.all)
            
            VStack {
                if addReminder {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.skyBlue.rawValue))
                        
                        VStack {
                            TextField("Title", text: $reminder.name)
                                .padding()
                                .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                .padding(EdgeInsets(top: 8, leading: 10, bottom: 0, trailing: 10))
                            
                            TextField("Message", text: $reminder.subtitle)
                                .padding()
                                .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                            
                            DatePicker("When:", selection: $reminder.time)
                                .padding()
                                .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                            
                            
                            HStack {
                                Text("Which Plant:")
                                
                                Picker("", selection: $reminder.ownerPlant) {
                                    ForEach(gardenPlants, id: \.self) { plant in
                                        Text(plant.name)
                                            .tag(OwnerPlant(id: plant.id, name: plant.name, addedEntry: false))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding()
                            .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(EdgeInsets(top: 8, leading: 10, bottom: 0, trailing: 10))
                            
                            HStack {
                                Toggle("Repeat:", isOn: $reminder.repeats.animation(.bouncy))
                                    .padding()
                                    .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                                
                                if reminder.repeats {
                                    Picker("Every:", selection: $reminder.howOften) {
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
                                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                                }
                            }
                            
                            HStack {
                                
                                if !showMessage {
                                    Button {
                                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                            if success {
                                                showMessage = true
                                            } else if error != nil {
                                                showMessage = false
                                            }
                                        }
                                    } label: {
                                        Text("Request Permission")
                                            .padding()
                                            .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                            .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                            .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                                    }
                                    .alert("Your all set to recieve Reminders!", isPresented: $showMessage) {
                                        Button("Thank you", role: .none) { }
                                    }
                                }
                                
                                Button {
                                    guard !reminder.name.isEmpty else { return }
                                    
//                                    scheduleReminder(at: reminder.time)
//                                    ReminderViewModel.shared.scheduleReminder(at: reminder.time, reminder: reminder)
                                    
                                    //to see all pending Notifications for debug
                                    UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
                                        for request in requests {
                                            if let timeIntervalTrigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                                                print(Date(timeIntervalSinceNow: timeIntervalTrigger.timeInterval))
                                            }
                                            
                                            if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                                                print(trigger.dateComponents)
                                            }
                                        }
                                    }
                                    
                                } label: {
                                    Text("Add Reminder")
                                        .padding()
                                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                                }
                            }
                            Spacer()
                            
                        }
                    }
                    .frame(width: 380, height: 300, alignment: .center)
                    .padding(EdgeInsets(top: 60, leading: 0, bottom: 80, trailing: 0))
                }
                
                if allReminders.isEmpty && !addReminder {
                    VStack {
                        Text("Looks like you don't have any Reminders.")
                        Text("Press the \(Text("Plus").foregroundStyle(Color(hex: GardenColors.skyBlue.rawValue))) button to add Reminders")
                    }
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                } else {
                    ScrollView {
                        VStack {
                            ForEach($allReminders, id: \.self) { remind in
                                NotifyCellView(allReminders: $allReminders, reminder: remind)
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
//                ForEach(gardenPlants, id: \.self) { plant in
//                    ForEach(plant.reminders, id: \.self) { reminder in
//                        allReminders.append(reminder)
//                    }
//                }
                print(allReminders, "onAppear")
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        showMessage = true
                    } else if error != nil {
                        showMessage = false
                    }
                }
            })
            .navigationTitle(addReminder ?  "Create Reminder" : "Your Reminders")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.bouncy) {
                            addReminder.toggle()
                        }
                    } label: {
                        Image(systemName: addReminder ? "minus" : "plus")
                            .foregroundStyle(Color(hex: GardenColors.skyBlue.rawValue))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        print("cleared all Reminders")
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

//#Preview {
//    NotificationsView()
//}

extension NotificationsView {
    
    func closeAndResetAddReminderMenu() {
        withAnimation(.bouncy) {
            addReminder = false
            reminder.name = ""
            reminder.subtitle = ""
            reminder.time = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
            reminder.repeats = false
            reminder.ownerPlant = OwnerPlant(id: 0, name: "", addedEntry: false)
        }
    }
}
