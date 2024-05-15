//
//  PlantDetailView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/23/24.
//

import SwiftUI
import SwiftData
import Vortex
import CoreLocation

struct PlantDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var navigation: Navigation
    
    @StateObject var plantViewModel = PlantsViewModel()
    @StateObject var locationDataManager = LocationDataManager()
    
    @State private var plantAdded = false
    
    @State private var showNative = false
    @State private var showIntroduced = false
    
    @State private var ableToGrowInUserLocation = false
    @State private var isActive = false
    
    @Query var gardenPlant: [YourPlant]
    
    var plantid: Int
    
    private let cornerRadius: CGFloat = 20
    
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
                    
                    if let plantImageURL = plant.imageURL {
                        plantImageView(image: plantImageURL)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        
                        VStack {
                            if let commonName = plant.commonName {
                                Text(commonName)
                                    .font(.largeTitle)
                            }
                            if let scientificName = plant.scientificName {
                                Text(scientificName)
                                    .font(.title2)
                            }
                        }
                        .padding()
                    }
                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                    .padding(.horizontal, 10)
                    
                    VStack {
                        Text("Disclaemer: The Information may not be 100% accurate")
                            .font(.footnote)
                    }
                    
                    
                    if let growthHabit = plant.mainSpecies.specifications.growthHabit {
                        Text(growthHabit)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                    }
                    
                    
                    VStack {
                        
                        if let edible = plant.mainSpecies.edible, let ediblePart = plant.mainSpecies.ediblePart {
                            
                            if edible {
                                if let vegetable = plant.mainSpecies.edible {
                                    Text(vegetable ? "Vegetable" : "Fruit")
                                        .font(.title2)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            VStack {
                                Text(edible ? "Edible:" : "Not Edible")
                                    .font(.title2)
                                    
                                
                                
                                ForEach(ediblePart, id: \.self) { part in
                                    Text(part)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
   
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                    
                    ableToPlantInLocationView()
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10))
                    
                    if let nativeDistributions = plant.mainSpecies.distribution?.native, let introducedDistributions = plant.mainSpecies.distribution?.introduced {
                        HStack {
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
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        
                        VStack(alignment: .leading) {
                            if showNative {
                                ForEach(nativeDistributions, id: \.self) { place in
                                    Text(place)
                                }
                            }
                            
                            if showIntroduced {
                                ForEach(introducedDistributions, id: \.self) { place in
                                    Text(place)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        
                    }
                    
                    VStack {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(Color(hex: GardenColors.plantGreen.rawValue))
                            
                            VStack {
                                Text("Growth Info:")
                                    .font(.largeTitle)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.horizontal, 10)
                                
                            }
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .padding(10)
                        }
                        .padding()
                        
                        if let growthDescription = plant.mainSpecies.growth.description {
                            //api every now and again returns a string of double quotes instead of nill
                            if growthDescription != "\"\"" {
                                Text(growthDescription)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        VStack(spacing: 10) {
                            if let sowing = plant.mainSpecies.growth.sowing {
                                
                                if sowing != "\"\"" {
                                    HStack {
                                        Text("Sowing:")
                                            .font(.title2)
                                        
                                        Text(sowing)
                                    }
                                }
                            }
                            
                            if let rowSpacing = plant.mainSpecies.growth.rowSpacing?.cm {
                                HStack {
                                    Text("Row Spacing:")
                                        .font(.title3)
                                    Text("cm: \(rowSpacing) In: \((Double(rowSpacing) * 0.39).formatted(.number.precision(.fractionLength(0...1))))")
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            if let spread = plant.mainSpecies.growth.spread?.cm {
                                HStack {
                                    Text("Spread:")
                                        .font(.title3)
                                    Text("cm: \(spread) In: \((Double(spread) * 0.39).formatted(.number.precision(.fractionLength(0...1))))")
                                }
                            }
                            
                            if let growthForm = plant.mainSpecies.specifications.growthForm {
                                VStack {
                                    Text("Growth Form:")
                                        .font(.title3)
                                    
                                    Text(growthForm)
                                }
                            }
                            
                            if let growthRate = plant.mainSpecies.specifications.growthRate {
                                VStack {
                                    Text("Growth Rate:")
                                        .font(.title3)
                                    
                                    Text(growthRate)
                                }
                            }
                            
                            if let daysToHarvest = plant.mainSpecies.growth.daysToHarvest {
                                HStack {
                                    Text("Days to harvest:")
                                        .font(.title3)
                                    
                                    Text("\(daysToHarvest)")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
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
                        .padding(.top, 5)
                        
                        
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
                        if plantAdded {
                            removePlantFromGarden()
                        } else {
                            addPlantToGarden()
                            navigation.popToRoot()
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
    
    func addPlantToGarden() {
        let plant = plantViewModel.plantDetail
        
        let newPlant = YourPlant(id: plant.id, imageURL: plant.imageURL ?? "image", name: plant.commonName ?? "", mainSpeciesId: plant.mainSpeciesId ?? 0, sowing: plant.mainSpecies.growth.sowing ?? "", daysToHarvest: plant.mainSpecies.growth.daysToHarvest ?? 0, rowSpacing: plant.mainSpecies.growth.rowSpacing?.cm ?? 0, spread: plant.mainSpecies.growth.spread?.cm ?? 0, growthMonths: plant.mainSpecies.growth.growthMonths ?? [], bloomMonths: plant.mainSpecies.growth.bloomMonths ?? [], fruitMonths: plant.mainSpecies.growth.growthMonths ?? [], light: plant.mainSpecies.growth.light ?? 5, growthHabit: plant.mainSpecies.specifications.growthHabit ?? "", growthRate: plant.mainSpecies.specifications.growthRate ?? "", entrys: [], notes: "", photos: [], reminders: [])
        
        modelContext.insert(newPlant)
        withAnimation(.smooth) {
            plantAdded = true
        }
    }
    
    func removePlantFromGarden() {
        let plant = plantViewModel.plantDetail
        
        for eachPlant in gardenPlant {
            if eachPlant.id == plant.id {
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
    
    func plantImageView(image: String) -> some View {
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 380, height: 200)
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
    
    func ableToPlantInLocationView() -> some View {
        VStack {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                
                let locationOfUser = CLLocation(latitude: Double(locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0), longitude: Double(locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0))
                
                //make bool call here to display if user can plant here
                HStack {
                    if ableToGrowInUserLocation {
                        Text("You are able to grow this plant")
                        
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
                    }
                }
                .onAppear {
                    getCityAndCountry(for: locationOfUser)
                }
                
                
            case .restricted, .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorize
                
                VStack(alignment: .leading) {
                    Text("location not found ")
                    
                    Button {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    } label: {
                        Text("Press here to enable locations")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            case .notDetermined:        // Authorization not determined yet.
                Text("Finding your location...")
                ProgressView()
                
            default:
                ProgressView()
            }
        }
    }
    
    func getCityAndCountry(for location: CLLocation) {
        
        location.placemark { placemark, error in
            
            if let placemark = placemark {
                
                print(placemark)
                let fullNameState = locationDataManager.statesDictionary[placemark.state]
                
                for place in plantViewModel.plantDetail.mainSpecies.distribution?.native ?? [] {
                    if place == fullNameState {
                        ableToGrowInUserLocation = true
                    }
                }
                
                for place in plantViewModel.plantDetail.mainSpecies.distribution?.introduced ?? [] {
                    if place == fullNameState {
                        ableToGrowInUserLocation = true
                    }
                }
            }
        }
    }
}

#Preview {
    PlantDetailView(plantid: 204029)
}
