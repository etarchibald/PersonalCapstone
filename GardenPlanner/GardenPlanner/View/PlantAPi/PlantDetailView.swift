//
//  PlantDetailView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/23/24.
//

import SwiftUI
import SwiftData
import Vortex

struct PlantDetailView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var plantViewModel = PlantsViewModel()
    
    @State private var plantAdded = false
    
    @Query var gardenPlant: [YourPlant]
    
    var plantid: Int
    
    var body: some View {
        let plant = plantViewModel.plantDetail
        
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        
                        VStack {
                            Text(plant.commonName ?? "")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            
                            Text(plant.scientificName ?? "scienicy plant name")
                                .font(.title2)
                        }
                        .padding()
                    }
                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                    .padding(.horizontal, 10)
                    
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
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .background(Color(hex: GardenColors.plantGreen.rawValue))
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .padding()
                        
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
                        PicturesSectionView(title: "Flowers:", pictures: flowerImages)
                    }
                    if let fruitImages = plant.mainSpecies.plantImages.fruitImages {
                        PicturesSectionView(title: "Fruit:", pictures: fruitImages)
                        
                    }
                    if let habitImages = plant.mainSpecies.plantImages.habitImages {
                        PicturesSectionView(title: "Habitat:", pictures: habitImages)
                    }
                    if let otherImages = plant.mainSpecies.plantImages.otherImages {
                        PicturesSectionView(title: "Other:", pictures: otherImages)
                    }
                }
                .onAppear(perform: {
                    fetchPlantDetails()
                })
                .toolbar {
                    Button {
                        let newPlant = YourPlant(id: plant.id, imageURL: plant.imageURL ?? "image", name: plant.commonName ?? "", growthMonths: plant.mainSpecies.growth.growthMonths ?? [], bloomMonths: plant.mainSpecies.growth.bloomMonths ?? [], fruitMonths: plant.mainSpecies.growth.growthMonths ?? [], light: plant.mainSpecies.growth.light ?? 5, growthHabit: plant.mainSpecies.specifications.growthHabit ?? "", growthRate: plant.mainSpecies.specifications.growthRate ?? "", entrys: [], notes: "", photos: [])
                        
                        modelContext.insert(newPlant)
                        withAnimation(.smooth) {
                            plantAdded = true
                        }
                    } label: {
                        Text(plantAdded ? "In your garden" : "Add to garden")
                        Image(systemName: plantAdded ? "leaf.fill" : "leaf")
                            .font(.system(size: 30))
                    }
                    .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
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
