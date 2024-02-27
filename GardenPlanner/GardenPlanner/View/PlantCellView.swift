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
        HStack {
            AsyncImage(url: URL(string: plant.imageURL ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 130, maxHeight: 130)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            VStack {
                Text(plant.commonName ?? "")
                    .padding()
                    .font(.title)
                    .foregroundStyle(.black)
                Text(plant.family)
                    .foregroundStyle(.black)
            }
//            Button {
//                
//            } label: {
//                Image(systemName: "leaf")
//                    .foregroundStyle(.green)
//                    .font(.largeTitle)
//            }
        }
    }
}

#Preview {
    PlantCellView(plant: Plant(id: 0, commonName: "Apple", scientificName: "Something funny", imageURL: "https://bs.plantnet.org/image/o/a42b6ba0beea54fbba5aaec0c785ac52ad3440c0", genus: "fruit", family: "possibly"))
}
