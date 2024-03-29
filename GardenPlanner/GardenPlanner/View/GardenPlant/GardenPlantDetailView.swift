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
    
    @Bindable var plant: YourPlant
    
    @State private var entry = Entry(id: UUID(), title: "", body: "", date: Date())
    
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
                    AsyncImage(url: URL(string: plant.imageURL)) { phase in
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
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        VStack {
                            Text(plant.name)
                                .font(.largeTitle)
                                .fontWeight(.light)
                                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
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
                            .font(.title2)
                            .frame(alignment: .trailing)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                    }
                    
                    VStack {
                        Text("Light on 0 to 10 scale: \(plant.light )")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                        
                        ProgressView(value: Double(plant.light ), total: 10)
                            .padding(.horizontal)
                            .tint(.yellow)
                    }
                    .progressViewStyle(.linear)
                    
                    
                    if !plant.growthMonths.isEmpty {
                        VStack {
                            Text("Growth Months:")
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                            
                            HStack {
                                ForEach(plant.growthMonths , id: \.self) { string in
                                    Text(string.capitalized)
                                        .font(.system(size: 22))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        }
                    }
                    
                    if !plant.bloomMonths.isEmpty {
                        
                        Text("Bloom Months:")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                        
                        HStack {
                            ForEach(plant.bloomMonths , id: \.self) { string in
                                Text(string.capitalized)
                                    .font(.system(size: 22))
                                
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    
                    if !plant.fruitMonths.isEmpty {
                        
                        Text("Bloom Months:")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                        
                        HStack {
                            ForEach(plant.fruitMonths , id: \.self) { string in
                                Text(string.capitalized)
                                    .font(.system(size: 22))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
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
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
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
                        .frame(height: 230, alignment: .center)
                    
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
            }
        }
    }
}
    
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: YourPlant.self, configurations: config)
        
        let gardenPlant = YourPlant(id: 0, imageURL: "https://bs.plantnet.org/image/o/4f45fd2d82661996f5d5a5613b39bdd1287a56bc", name: "Alpine Strawberry", growthMonths: ["apr", "may", "jun"], bloomMonths: [], fruitMonths: ["apr", "may", "jun"], light: 5, growthHabit: "Forb/herb", growthRate: "Rapid", entrys: [], notes: "", photos: [])
        
        return GardenPlantDetailView(plant: gardenPlant)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
