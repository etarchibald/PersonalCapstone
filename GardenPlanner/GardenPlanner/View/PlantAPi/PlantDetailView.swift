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
    
    @State private var showNative = false
    @State private var showIntroduced = false
    
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
                    plantImageView(image: plant.imageURL ?? "image")
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
                        if let edible = plant.mainSpecies.edible, let ediblePart = plant.mainSpecies.ediblePart {
                            VStack {
                                Text(edible ? "Edible" : "Not Edible")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                                
                                
                                
                                ForEach(ediblePart, id: \.self) { part in
                                    Text(part)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            if edible {
                                if let vegetable = plant.mainSpecies.edible {
                                    Text(vegetable ? "Vegetable" : "Fruit")
                                        .font(.title2)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 10)
                                }
                            }
                        }
                        
                        Text(plant.mainSpecies.specifications.growthHabit ?? "")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                    
                    VStack {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(hex: GardenColors.plantGreen.rawValue))
                            
                            VStack {
                                Text("Growth Info:")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.horizontal, 10)
                                
                                if let observations = plant.observations, let rank = plant.mainSpecies.rank {
                                    HStack {
                                        Text(observations)
                                        Spacer()
                                        Text(rank.capitalized)
                                    }
                                }
                                
                            }
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .padding(10)
                        }
                        .padding()
                        
                        if let growthDescription = plant.mainSpecies.growth.description {
                            Text(growthDescription)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                                .multilineTextAlignment(.leading)
                        }
                        
                        VStack(alignment: .leading) {
                            if let sowing = plant.mainSpecies.growth.sowing {
                                VStack(alignment: .leading) {
                                    Text("Sowing:")
                                        .font(.title2)
                                    
                                    Text(sowing)
                                }
                            }
                            
                            if let rowSpacing = plant.mainSpecies.growth.rowSpacing?.cm {
                                HStack {
                                    Text("Row Spacing:")
                                        .font(.title3)
                                    Text("cm: \(rowSpacing) In: \(Double(rowSpacing) * 0.39)")
                                }
                            }
                            
                            if let spread = plant.mainSpecies.growth.spread?.cm {
                                HStack {
                                    Text("Spread:")
                                        .font(.title3)
                                    Text("cm: \(spread) In: \(Double(spread) * 0.39)")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        VStack {
                            Text("Light on 0 to 10 scale: \(plant.mainSpecies.growth.light ?? 5)")
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                            
                            ProgressView(value: Double(plant.mainSpecies.growth.light ?? 5), total: 10)
                                .padding(.horizontal)
                                .tint(.yellow)
                        }
                        .progressViewStyle(.linear)
                        
                        
                        if let growthMonths = plant.mainSpecies.growth.growthMonths {
                            GardenPlantDetailMonthsView(title: "Growth Months", months: growthMonths)
                        }
                        
                        if let bloomMonths = plant.mainSpecies.growth.bloomMonths {
                            GardenPlantDetailMonthsView(title: "Bloom Months:", months: bloomMonths)
                        }
                        
                        if let fruitMonths = plant.mainSpecies.growth.fruitMonths {
                            GardenPlantDetailMonthsView(title: "Fruit Months:", months: fruitMonths)
                        }
                        if let flowerColors = plant.mainSpecies.flower.color {
                            GardenPlantDetailMonthsView(title: "Flower Color(s):", months: flowerColors)
                        }
                    }
                    
                    if let growthForm = plant.mainSpecies.specifications.growthForm {
                        VStack {
                            Text("Growth Form:")
                                .font(.title3)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                            
                            Text(growthForm)
                                .padding(.horizontal, 10)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let growthRate = plant.mainSpecies.specifications.growthRate {
                        VStack {
                            Text("Growth Rate:")
                                .font(.title3)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                            
                            Text(growthRate)
                                .padding(.horizontal, 10)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let daysToHarvest = plant.mainSpecies.growth.daysToHarvest {
                        HStack {
                            Text("Days to harvest:")
                                .font(.title3)
                            
                            Text("\(daysToHarvest)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    }
                    
                    if let nativeDistributions = plant.mainSpecies.distribution?.native, let introducedDistributions = plant.mainSpecies.distribution?.introduced {
                        VStack(alignment: .leading) {
                            Text("Distributions:")
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Native:")
                                        .font(.title3)
                                    
                                    Button {
                                        withAnimation(.bouncy) {
                                            showNative.toggle()
                                        }
                                    } label: {
                                        Image(systemName: showNative ? "chevron.down" : "chevron.right")
                                            .contentTransition(.symbolEffect(.replace))
                                    }
                                }
                                
                                if showNative {
                                    ForEach(nativeDistributions, id: \.self) { place in
                                        Text(place)
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Introduced:")
                                        .font(.title3)
                                    
                                    Button {
                                        withAnimation(.bouncy) {
                                            showIntroduced.toggle()
                                        }
                                    } label: {
                                        Image(systemName: showIntroduced ? "chevron.down" : "chevron.right")
                                            .contentTransition(.symbolEffect(.replace))
                                    }
                                }
                                if showIntroduced {
                                    ForEach(introducedDistributions, id: \.self) { place in
                                        Text(place)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 0))
                        
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
                        let newPlant = YourPlant(id: plant.id, imageURL: plant.imageURL ?? "image", name: plant.commonName ?? "", sowing: plant.mainSpecies.growth.sowing ?? "", daysToHarvest: plant.mainSpecies.growth.daysToHarvest ?? 0, rowSpacing: plant.mainSpecies.growth.rowSpacing?.cm ?? 0, spread: plant.mainSpecies.growth.spread?.cm ?? 0, growthMonths: plant.mainSpecies.growth.growthMonths ?? [], bloomMonths: plant.mainSpecies.growth.bloomMonths ?? [], fruitMonths: plant.mainSpecies.growth.growthMonths ?? [], light: plant.mainSpecies.growth.light ?? 5, growthHabit: plant.mainSpecies.specifications.growthHabit ?? "", growthRate: plant.mainSpecies.specifications.growthRate ?? "", entrys: [], notes: "", photos: [], reminders: [])
                        
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
    
    func plantImageView(image: String) -> some View {
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
                Image(systemName: "tree")
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
    PlantDetailView(plantid: 264892)
}
