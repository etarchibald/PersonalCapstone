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
    @StateObject var plantViewModel = PlantsViewModel()
    
    @State private var plantAdded = false
    
    @Query var gardenPlant: [YourPlant]
    
    var plantid: Int
    
    var body: some View {
        let plant = plantViewModel.plantDetail
        
        Button {
            let newPlant = YourPlant(id: plant.id, imageURL: plant.imageURL ?? "image", name: plant.commonName ?? "", growthMonths: plant.mainSpecies.growth.growthMonths ?? [], bloomMonths: plant.mainSpecies.growth.bloomMonths ?? [], fruitMonths: plant.mainSpecies.growth.growthMonths ?? [], light: plant.mainSpecies.growth.light ?? 5, growthHabit: plant.mainSpecies.specifications.growthHabit ?? "", growthRate: plant.mainSpecies.specifications.growthRate ?? "", entrys: [], notes: "")
            
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
            AsyncImage(url: URL(string: plant.imageURL ?? "image")) { phase in
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
                    Image(systemName: "tree")
                        .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
                        .font(.system(size: 100))
                        .frame(width: 200, height: 200, alignment: .center)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(plant.commonName ?? "")
                .font(.largeTitle)
            Text(plant.scientificName ?? "scienicy plant name")
                .font(.title2)
            
            HStack {
                VStack {
                    plant.mainSpecies.edible.map {
                        Text($0 ? "Edible" : "Not Edible")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                        
                    }
                    
                    ForEach(plant.mainSpecies.ediblePart ?? [], id: \.self) { part in
                        Text(part)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    }
                }
                
                if plant.mainSpecies.edible ?? false {
                    Text(plant.vegetable ?? true ? "Vegetable" : "Fruit")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                }
                
                Text(plant.mainSpecies.specifications.growthHabit ?? "")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            VStack {
                plant.mainSpecies.flower.color.map { _ in Text("Flower Color(s):") }
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                
                HStack {
                    ForEach(plant.mainSpecies.flower.color ?? [], id: \.self) { color in
                        Text(color.capitalized)
                            .font(.system(size: 22))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            }
            
            VStack {
                Text("Growth Info:")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                plant.mainSpecies.growth.description.map {
                    Text($0)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                        .multilineTextAlignment(.leading)
                }
                
                VStack {
                    Text("Light on 0 to 10 scale: \(plant.mainSpecies.growth.light ?? 5)")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    
                    ProgressView(value: Double(plant.mainSpecies.growth.light ?? 5), total: 10)
                        .padding(.horizontal)
                        .tint(.yellow)
                }
                .progressViewStyle(.linear)
                
                
                if plant.mainSpecies.growth.growthMonths != nil {
                    VStack {
                        Text("Growth Months:")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                        
                        HStack {
                            ForEach(plant.mainSpecies.growth.growthMonths ?? [], id: \.self) { string in
                                Text(string.capitalized)
                                    .font(.system(size: 22))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                }
                
                if plant.mainSpecies.growth.bloomMonths != nil {
                    
                    Text("Bloom Months:")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    
                    HStack {
                        ForEach(plant.mainSpecies.growth.bloomMonths ?? [], id: \.self) { string in
                            Text(string.capitalized)
                                .font(.system(size: 22))
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                }
                
                if plant.mainSpecies.growth.fruitMonths != nil {
                    HStack {
                        ForEach(plant.mainSpecies.growth.fruitMonths ?? [], id: \.self) { string in
                            Text(string.capitalized)
                                .font(.system(size: 22))
                        }
                    }
                }
            }
            
            if plant.mainSpecies.specifications.growthRate != nil {
                VStack {
                    Text("Growth Rate:")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    
                    Text(plant.mainSpecies.specifications.growthRate ?? "")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
            }
            
            if let flowerImages = plant.mainSpecies.plantImages.flowerImages {
                Text("Flowers:")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                PlantPictureScrollView(pictures: flowerImages)
                    .frame(height: 230, alignment: .center)
            }
            if let fruitImages = plant.mainSpecies.plantImages.fruitImages {
                Text("Fruit:")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                PlantPictureScrollView(pictures: fruitImages)
                    .frame(height: 230, alignment: .center)
                
            }
            if let habitImages = plant.mainSpecies.plantImages.habitImages {
                Text("Habitat:")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                PlantPictureScrollView(pictures: habitImages)
                    .frame(height: 230, alignment: .center)
            }
            if let otherImages = plant.mainSpecies.plantImages.otherImages {
                Text("Other Pictures:")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                PlantPictureScrollView(pictures: otherImages)
                    .frame(height: 230, alignment: .center)
            }
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
