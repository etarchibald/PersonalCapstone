//
//  GardenView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/27/24.
//

import SwiftUI
import SwiftData


struct GardenView: View {
    @StateObject var plantViewModel = PlantsViewModel()
    
    @Query var myGarden: [GardenPlant]
    
    var body: some View {
        NavigationStack() {
            VStack {
                VStack {
                    ScrollView {
                        if myGarden.isEmpty {
                            Spacer(minLength: 300)
                            VStack {
                                Text("Looks like your garden is empty.")
                                Text("Press the \(Text("Plus").foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))) button to add Plants")
                            }
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding()
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 20, pinnedViews: [], content: {
                                
                                ForEach(myGarden, id: \.self) { gardenPlant in
                                    NavigationLink {
                                        GardenPlantDetailView(plant: gardenPlant)
                                    } label: {
                                        GardenPlantCellView(imageURl: gardenPlant.imageURL,name: gardenPlant.name)
                                    }
                                }
                                
                            })
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    NavigationLink {
                        NotificationsView()
                    } label: {
                        Image(systemName: "bell.fill")
                            .frame(maxWidth: 50, maxHeight: 50)
                            .font(.title2)
                            .background(Color(hex: GardenColors.skyBlue.rawValue))
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .clipShape(Circle())
                    }
                    
                    NavigationLink {
                        PlantAPIView()
                    } label: {
                        Image(systemName: "plus")
                            .frame(maxWidth: 70, maxHeight: 70)
                            .font(.largeTitle)
                            .background(Color(hex: GardenColors.plantGreen.rawValue))
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .clipShape(Circle())
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Image(systemName: "")
                            .frame(maxWidth: 50, maxHeight: 50)
                            .background()
                            .foregroundStyle(Color.clear)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}

#Preview {
    GardenView()
}
