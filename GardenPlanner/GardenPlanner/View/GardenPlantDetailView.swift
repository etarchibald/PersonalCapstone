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
    
    @State private var showingAlert = false
    
    var plant: GardenPlant
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: plant.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300, alignment: .center)
                case .failure:
                    Image(systemName: "tree.fill")
                        .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
                        .font(.system(size: 100))
                        .frame(width: 200, height: 200, alignment: .center)
                @unknown default:
                    EmptyView()
                }
            }
            .padding()
                    
//                    Button {
//
//                   } label: {
//                       Image(systemName: "camera")
//                           .frame(width: 70, height: 70)
//                           .background(Color(hex: GardenColors.plantGreen.rawValue))
//                           .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
//                           .clipShape(Circle())
//                           .font(.title)
//                   }
//                   .padding(EdgeInsets(top: 0, leading: 300, bottom: 0, trailing: 0))
            
            ZStack {
                RoundedRectangle(cornerRadius: 70, style: .continuous)
                    .fill(Color(hex: GardenColors.skyBlue.rawValue))
                VStack {
                    Text(plant.name)
                        .font(.largeTitle)
                }
                .padding()
            }
            .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 70, style: .continuous)
                    .fill(Color(hex: GardenColors.plantGreen.rawValue))
                
                VStack {
                    Text("Notes")
                        .font(.largeTitle)
                        .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                }
                .padding()
            }
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 70, style: .continuous)
                    .fill(Color(hex: GardenColors.dirtBrown.rawValue))
                
                VStack {
                    Text("Alarms")
                        .font(.largeTitle)
                        .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                }
                .padding()
            }
            .padding()
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAlert = true
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.red)
                }
                .alert("Are you sure you want to delete \(plant.name)?", isPresented: $showingAlert) {
                    Button("Delete", role: .destructive) {
                        dismiss()
                        modelContext.delete(plant)
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        
        Button {
            
        } label: {
            Image(systemName: "save")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: GardenPlant.self, configurations: config)
    
    let gardenPlant = GardenPlant(id: 1, imageURL: "https://bs.plantnet.org/image/o/b4e83f95dce979319ad70321a9023400d7bf5f48", name: "Avocado", notes: "")
    
    return GardenPlantDetailView(plant: gardenPlant)
        .modelContainer(container)
}
