//
//  GardenPlantDetailView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/1/24.
//

import SwiftUI
import SwiftData
import Vortex
import PhotosUI

struct GardenPlantDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var showingDeleteAlert = false
    @State private var showingAddEntry = false
    @State private var showingNotes = false
    @State private var showCamera = false
    @State private var showReminders = false
    @State private var showMessage = false
    
    @Bindable var plant: YourPlant
    
    @State private var entry = Entry(id: UUID(), title: "", body: "", date: Date())
    @State private var reminder = Reminder(id: UUID(), name: "", subtitle: "", time: Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date(), repeats: false, howOften: RepeatingNotifications.daily, ownerPlant: OwnerPlant(id: 0, name: "", addedEntry: false))
    
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Data]()
    
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
                ScrollView {
                    plantPhotoView(image: plant.imageURL)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        VStack {
                            Text(plant.name)
                                .font(.largeTitle)
                                .fontWeight(.light)
                                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                .onAppear {
                                    print(plant.id)
                                }
                        }
                        .padding()
                    }
                    .padding()
                    
                    HStack {
                        Text("Growth Info:")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        
                        Text(plant.growthHabit)
                            .font(.title3)
                            .frame(alignment: .trailing)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                    }
                    
                    VStack {
                        Text("Light on 0 to 10 scale: \(plant.light )")
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                        
                        ProgressView(value: Double(plant.light), total: 10)
                            .padding(.horizontal)
                            .tint(.yellow)
                    }
                    .progressViewStyle(.linear)
                    
                    
                    if !plant.growthMonths.isEmpty {
                        GardenPlantDetailMonthsView(title: "Growth Months:", months: plant.growthMonths)
                    }
                    
                    if !plant.bloomMonths.isEmpty {
                        GardenPlantDetailMonthsView(title: "Bloom Months:", months: plant.bloomMonths)
                    }
                    
                    if !plant.fruitMonths.isEmpty {
                        GardenPlantDetailMonthsView(title: "Fruit Months:", months: plant.fruitMonths)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        VStack {
                            HStack {
                                Text("Entrys:")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                
                                Button {
                                    withAnimation(.bouncy) {
                                        showingAddEntry.toggle()
                                    }
                                } label: {
                                    Image(systemName: showingAddEntry ? "minus" : "plus")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .fontWeight(.light)
                            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                            
                            if showingAddEntry {
                                
                                Text("Add Entrys to help keep track of your plant. Press and hold to delete them")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                
                                HStack {
                                    TextField("Title", text: $entry.title)
                                        .padding()
                                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                    
                                    DatePicker("", selection: $entry.date, displayedComponents: [.date])
                                        .padding()
                                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                                }
                                
                                TextField("Body", text: $entry.body)
                                    .padding()
                                    .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.horizontal, 10)
                                
                                Button {
                                    guard !entry.title.isEmpty else { return }
                                    withAnimation(.bouncy) {
                                        showingAddEntry = false
                                    }
                                    let newEntry = Entry(id: UUID(), title: entry.title, body: entry.body, date: entry.date)
                                    withAnimation(.bouncy) {
                                        plant.entrys.append(newEntry)
                                    }
                                    entry.title = ""
                                    entry.body = ""
                                    entry.date = Date()
                                } label: {
                                    Text("Add Entry")
                                        .padding()
                                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                                }
                                
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                    
                    VStack {
                        EntryCellView(entrys: $plant.entrys)
                    }
                    .frame(height: plant.entrys.isEmpty ? 0 : 350)
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        
                        VStack {
                            HStack {
                                Text("Reminders:")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                
                                Button {
                                    withAnimation(.bouncy) {
                                        showReminders.toggle()
                                    }
                                } label: {
                                    Image(systemName: showReminders ? "minus" : "plus")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .fontWeight(.light)
                            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                            
                            
                            
                            if showReminders {
                                TextField("Title", text: $reminder.name)
                                    .padding()
                                    .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.horizontal, 10)
                                
                                TextField("Message", text: $reminder.subtitle)
                                    .padding()
                                    .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                                
                                DatePicker("When:", selection: $reminder.time)
                                    .padding()
                                    .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .clipShape(RoundedRectangle(cornerRadius: 20 ))
                                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                                
                                HStack {
                                    Toggle("Repeat:", isOn: $reminder.repeats.animation(.bouncy))
                                        .padding()
                                        .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
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
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 0, trailing: 10))
                                        }
                                        .alert("Your all set to recieve Reminders!", isPresented: $showMessage) {
                                            Button("Thank you", role: .none) { }
                                        }
                                    }
                                    
                                    Button {
                                        guard !reminder.name.isEmpty else { return }
                                        
                                        let newReminder = Reminder(id: UUID(), name: reminder.name, subtitle: reminder.subtitle, time: reminder.time, repeats: reminder.repeats, howOften: reminder.howOften, ownerPlant: OwnerPlant(id: plant.id, name: plant.name, addedEntry: false))
                                        
                                        ReminderViewModel.shared.scheduleReminder(reminder: newReminder)
                                        
                                        withAnimation(.bouncy) {
                                            plant.reminders.append(newReminder)
                                            showReminders = false
                                            reminder.name = ""
                                            reminder.subtitle = ""
                                            reminder.time = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
                                            reminder.repeats = false
                                        }
                                        
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
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        ReminderCellView(allReminders: $plant.reminders)
                            .padding()
                    }
                    .frame(height: plant.reminders.isEmpty ? 0 : 350)
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        
                        VStack {
                            HStack {
                                Text("Notes:")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .padding()
                                
                                Button {
                                    withAnimation(.bouncy) {
                                        showingNotes.toggle()
                                    }
                                } label: {
                                    Image(systemName: showingNotes ? "minus" : "plus")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding()
                            }
                            .fontWeight(.light)
                            
                            if showingNotes {
                                TextEditor(text: $plant.notes)
                                    .padding()
                                    .frame(height: 300)
                                    .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        
                        VStack {
                            HStack {
                                Text("Pictures:")
                                    .font(.title)
                                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    .padding()
                                
                                HStack(spacing: 0) {
                                    Button {
                                        showCamera.toggle()
                                    } label: {
                                        Image(systemName: "camera")
                                            .font(.largeTitle)
                                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    }
                                    .padding(.horizontal)
                                    .fullScreenCover(isPresented: $showCamera) {
                                        AccessCameraView(selectedImages: $selectedImages)
                                    }
                                    
                                    PhotosPicker(selection: $pickerItems, matching: .images) {
                                        Image(systemName: "photo.stack")
                                            .font(.largeTitle)
                                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    }
                                    .padding()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .fontWeight(.light)
                        }
                    }
                    .padding()
                    .onChange(of: pickerItems) {
                        Task {
                            selectedImages.removeAll()

                            for item in pickerItems {
                                if let loadedImage = try await item.loadTransferable(type: Data.self) {
                                    withAnimation(.bouncy) {
                                        selectedImages.append(loadedImage)
                                        plant.photos.append(UserPhotos(id: UUID(), dateAdded: Date(), photo: loadedImage))
                                    }
                                }
                            }
                        }
                    }
                    
                    GardenPlantDetailPicturesView(userPhotos: $plant.photos)
                        .frame(height: plant.photos.isEmpty ? 0 : 230, alignment: .center)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundStyle(.red)
                        }
                        .alert("Are you sure you want to delete \(plant.name)?", isPresented: $showingDeleteAlert) {
                            Button("Delete", role: .destructive) {
                                dismiss()
                                //it throws bugs in swiftData if entrys is not an empty arrray
                                plant.entrys = []
                                plant.photos = []
                                
                                for reminder in plant.reminders {
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
                                }
                                
                                plant.reminders = []
                                modelContext.delete(plant)
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Save")
                        }
                        .padding()
                    }
                }
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            showMessage = true
                        } else if error != nil {
                            showMessage = false
                        }
                    }
                    
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
    }
    
    func plantPhotoView(image: String) -> some View {
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 380, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous), style: FillStyle())
                    .shadow(radius: 10)
            case .failure:
                Image(systemName: "tree.fill")
                    .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
                    .font(.system(size: 100))
                    .frame(width: 200, height: 200, alignment: .center)
            @unknown default:
                EmptyView()
            }
        }
    }
}
    
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: YourPlant.self, configurations: config)
        
        let gardenPlant = YourPlant(id: 0, imageURL: "https://bs.plantnet.org/image/o/4f45fd2d82661996f5d5a5613b39bdd1287a56bc", name: "Alpine StrawBerry", mainSpeciesId: 0, sowing: "Something", daysToHarvest: 60, rowSpacing: 35, spread: 30, growthMonths: [], bloomMonths: [], fruitMonths: [], light: 8, growthHabit: "Forb/herb", growthRate: "Rapid", entrys: [], notes: "", photos: [], reminders: [])
        
        return GardenPlantDetailView(plant: gardenPlant)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
