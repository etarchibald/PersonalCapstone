//
//  GardenPlantDetailView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/1/24.
//

import SwiftUI
import SwiftData

struct GardenPlantDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var showingDeleteAlert = false
    @State private var showingAddEntry = true
    
    @Bindable var plant: YourPlant
    
    @State private var noteEntry = Entry(id: UUID(), title: "", body: "", date: Date())
    
    var body: some View {
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
                    .fill(Color(hex: GardenColors.dirtBrown.rawValue))
                VStack {
                    Text(plant.name)
                        .font(.largeTitle)
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
                    .fill(Color(hex: GardenColors.dirtBrown.rawValue))
                VStack {
                    HStack {
                        Text("Entrys:")
                            .font(.largeTitle)
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                        
                        Button {
                            showingAddEntry.toggle()
                        } label: {
                            Image(systemName: showingAddEntry ? "minus" : "plus")
                                .font(.largeTitle)
                                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                    
                    if showingAddEntry {
                        TextField("Title", text: $noteEntry.title)
                            .padding()
                            .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .clipShape(RoundedRectangle(cornerRadius: 20 ))
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                        TextField("Body", text: $noteEntry.body)
                            .padding()
                            .background(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .clipShape(RoundedRectangle(cornerRadius: 20 ))
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                        Button {
                            
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
            .padding()
            
            //For each of entry cells
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
                        modelContext.delete(plant)
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        
        Button {
            dismiss()
        } label: {
            Text("Save")
        }
    }
}
    
    #Preview {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: YourPlant.self, configurations: config)
        
        let gardenPlant = YourPlant(id: 0, imageURL: "https://bs.plantnet.org/image/o/4f45fd2d82661996f5d5a5613b39bdd1287a56bc", name: "Alpine Strawberry", growthMonths: ["apr", "may", "jun"], bloomMonths: ["apr", "may", "jun"], fruitMonths: ["apr", "may", "jun"], light: 5, growthHabit: "Forb/herb", growthRate: "Rapid", entrys: [], notes: "")
        
        return GardenPlantDetailView(plant: gardenPlant)
            .modelContainer(container)
    }
