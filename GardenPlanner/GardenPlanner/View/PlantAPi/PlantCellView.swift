//
//  PlantCellView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import SwiftUI
import SwiftData

struct PlantCellView: View {
    @Environment(\.modelContext) var modelContext
    
    @StateObject var plantViewModel = PlantsViewModel()
    
    @Query var gardenPlant: [YourPlant]
    
    @State private var plantAdded = false
    
    var plant: Plant
    
    init(plant: Plant) {
        self.plant = plant
    }
    
    private let cornerRadius: CGFloat = 20
    private let imageWidth: CGFloat = 60
    private let imageHeight: CGFloat = 85

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(hex: GardenColors.plantGreen.rawValue))
                .shadow(radius: 10)
            
            HStack(spacing: 16) {
                plantImageView()
                
                VStack(alignment: .leading) {
                    if let commonName = plant.commonName {
                        Text(commonName)
                            .fontWeight(.semibold)
                    }
                    
                    Text(plant.family)
                        .font(.subheadline)
                }
                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button {
                    if plantAdded {
                        removePlantFromGarden()
                    } else {
                        Task {
                            await plantViewModel.fetchPlantDetail(using: plant.id)
                            addPlantToGarden()
                        }
                    }
                    
                } label: {
                    Image(systemName: plantAdded ? "leaf.fill" : "leaf")
                        .font(.title2)
                        .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                        .contentTransition(.symbolEffect(.replace))
                }
                .padding(.horizontal)
            }
            .padding()
            .onAppear {
                //check and see if its already in garden
                updateUI()
            }
        }
    }
    
    func plantImageView() -> some View {
        AsyncImage(url: URL(string: plant.imageURL ?? "image")) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: imageWidth, height: imageHeight)
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous), style: FillStyle())
                    .shadow(radius: 5)
            case .failure:
                Image(systemName: "carrot.fill")
                    .foregroundStyle(.orange)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: imageHeight)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    func updateUI() {
        for plant in gardenPlant {
            if plant.mainSpeciesId == self.plant.id {
                self.plantAdded = true
            }
        }
    }
    
    func addPlantToGarden() {
        let plant = plantViewModel.plantDetail
        
        let newPlant = YourPlant(id: plant.id, imageURL: plant.imageURL ?? "image", name: plant.commonName ?? "", mainSpeciesId: plant.mainSpeciesId ?? 0, sowing: plant.mainSpecies.growth.sowing ?? "", daysToHarvest: plant.mainSpecies.growth.daysToHarvest ?? 0, rowSpacing: plant.mainSpecies.growth.rowSpacing?.cm ?? 0, spread: plant.mainSpecies.growth.spread?.cm ?? 0, growthMonths: plant.mainSpecies.growth.growthMonths ?? [], bloomMonths: plant.mainSpecies.growth.bloomMonths ?? [], fruitMonths: plant.mainSpecies.growth.growthMonths ?? [], light: plant.mainSpecies.growth.light ?? 5, growthHabit: plant.mainSpecies.specifications.growthHabit ?? "", growthRate: plant.mainSpecies.specifications.growthRate ?? "", entrys: [], notes: "", photos: [], reminders: [])
        
        modelContext.insert(newPlant)
        withAnimation(.smooth) {
            plantAdded = true
        }
    }
    
    func removePlantFromGarden() {
        
        for eachPlant in gardenPlant {
            if eachPlant.mainSpeciesId == plant.id {
                eachPlant.entrys = []
                eachPlant.photos = []
                
                for reminder in eachPlant.reminders {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
                }
                
                eachPlant.reminders = []
                modelContext.delete(eachPlant)
                break
            }
        }
        
        withAnimation(.smooth) {
            plantAdded = false
        }
    }
    
}

#Preview {
    PlantCellView(plant: Plant(id: 0, commonName: "Apple", scientificName: "Something funny", imageURL: "https://bs.plantnet.org/image/o/4f56a83172d92798bf754e81e7cf2f6ec271d278", genus: "fruit", family: "possibly"))
}
