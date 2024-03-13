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
                AsyncImage(url: URL(string: plant.imageURL ?? "image")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 130, maxHeight: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous), style: FillStyle())
                            .shadow(radius: 10)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                            .shadow(radius: 5)
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
                        .font(.title)
                    Text(plant.family)
                        .font(.title2)
                }
                .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 20))
            }
        }
    }
}

#Preview {
    PlantCellView(plant: Plant(id: 0, commonName: "Apple", scientificName: "Something funny", imageURL: "https://bs.plantnet.org/image/o/4f56a83172d92798bf754e81e7cf2f6ec271d278", genus: "fruit", family: "possibly"))
}
