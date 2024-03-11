//
//  PlantCellView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import SwiftUI

struct PlantCellView: View {
    
    var plant: Plant
    
    init(plant: Plant) {
        self.plant = plant
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .fill(Color(hex: GardenColors.plantGreen.rawValue))
                .frame(width: 380, height: 180)
                .shadow(radius: 10)
            
            HStack {
                AsyncImage(url: URL(string: plant.imageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .border(Color.white, width: 3)
                            .frame(maxWidth: 120, maxHeight: 140)
                    case .failure:
                        Image(systemName: "carrot.fill")
                            .foregroundStyle(.orange)
                            .font(.system(size: 80))
                            .frame(maxWidth: 120, maxHeight: 140)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack {
                    Text(plant.commonName ?? "")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .font(.title)
                    Text(plant.family)
                        .font(.title2)
                }
                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
            }
        }
    }
}

#Preview {
    PlantCellView(plant: Plant(id: 0, commonName: "Apple", scientificName: "Something funny", imageURL: "https:", genus: "fruit", family: "possibly"))
}
