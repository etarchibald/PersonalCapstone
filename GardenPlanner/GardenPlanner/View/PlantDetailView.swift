//
//  PlantDetailView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/23/24.
//

import SwiftUI
import SwiftData

struct PlantDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @StateObject var plantViewModel = PlantsViewModel()
    
    @State private var plantAdded = false
    
    @Query var gardenPlant: [GardenPlant]
    
    var plantid: Int
    
    var body: some View {
        let plant = plantViewModel.plantDetail
        
        VStack {
            Button {
                let newPlant = GardenPlant(id: plantViewModel.plantDetail.id, imageURL: plantViewModel.plantDetail.imageURL ?? "image", name: plantViewModel.plantDetail.commonName ?? "Plant", notes: "")
                modelContext.insert(newPlant)
                plantAdded = true
            } label: {
                Text(plantAdded ? "In your garden" : "Add to garden")
                Image(systemName: plantAdded ? "leaf.fill" : "leaf")
                    .font(.system(size: 40))
            }
            .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
            .frame(width: 380, alignment: .trailing)
            
            ScrollView {
                AsyncImage(url: URL(string: plantViewModel.plantDetail.imageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .border(Color.white, width: 3)
                            .frame(maxWidth: 130, maxHeight: 150)
                    case .failure:
                        Image(systemName: "tree.fill")
                            .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
                            .font(.system(size: 100))
                            .frame(width: 200, height: 200, alignment: .center)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Text(plant.commonName ?? "No commonName")
                Text(plant.scientificName ?? "scienicy plant name")
                Text(plant.vegetable ?? true ? "Fruit" : "Vegetable")
                ForEach(plant.mainSpecies.ediblePart ?? [], id: \.self) { part in
                    Text(part)
                }
                
                Text(plant.mainSpecies.edible ?? false ? "Edible" : "NOT Edible")
                
                HStack {
                    plant.mainSpecies.flower.color.map { _ in Text("Flower Color(s):") }
                    ForEach(plant.mainSpecies.flower.color ?? [], id: \.self) { color in
                        Text(color)
                    }
                }
                
                VStack {
                    Text("Growth Info:")
                    plant.mainSpecies.growth.description.map { Text($0) }
                    Text("How much light on 0 to 10 scale: \(plant.mainSpecies.growth.light ?? 5)")
                    HStack {
                        ForEach(plant.mainSpecies.growth.growthMonths ?? [], id: \.self) { string in
                            Text(string)
                        }
                    }
                    HStack {
                        ForEach(plant.mainSpecies.growth.bloomMonths ?? [], id: \.self) { string in
                            Text(string)
                        }
                    }
                    HStack {
                        ForEach(plant.mainSpecies.growth.fruitMonths ?? [], id: \.self) { string in
                            Text(string)
                        }
                    }
                }
                
                VStack {
                    Text(plant.mainSpecies.specifications.growthHabit ?? "")
                    Text(plant.mainSpecies.specifications.growthRate ?? "")
                }
                
                VStack {
                    if let flowerImages = plant.mainSpecies.plantImages.flowerImages {
                        Text("Flowers:")
                        PlantPictureScrollView(pictures: flowerImages)
                            .padding(.leading)
                    }
                    if let fruitImages = plant.mainSpecies.plantImages.fruitImages {
                        Text("Fruit:")
                        PlantPictureScrollView(pictures: fruitImages)
                            .padding(.leading)
                    }
                    if let habitImages = plant.mainSpecies.plantImages.habitImages {
                        Text("Habitat:")
                        PlantPictureScrollView(pictures: habitImages)
                            .padding(.leading)
                    }
                    if let otherImages = plant.mainSpecies.plantImages.otherImages {
                        Text("Other Pictures:")
                        PlantPictureScrollView(pictures: otherImages)
                            .padding(.leading)
                    }
                }
            }
            .navigationTitle(plant.commonName ?? "No commonName")
            .navigationBarTitleTextColor(Color(hex: GardenColors.plantGreen.rawValue))
        }
        .onAppear(perform: {
            fetchPlantDetails()
        })
    }
    
    func fetchPlantDetails() {
        Task {
            await plantViewModel.fetchPlantDetail(using: plantid)
            updateUI()
        }
    }
    
    func updateUI() {
        for plant in gardenPlant {
            if plant.id == plantViewModel.plantDetail.id {
                self.plantAdded = true
            }
        }
    }
}

#Preview {
    PlantDetailView(plantid: 266004)
}

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}
