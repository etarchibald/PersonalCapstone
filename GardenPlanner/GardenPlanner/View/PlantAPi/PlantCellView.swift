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
            }
            .padding()
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
    
}

#Preview {
    PlantCellView(plant: Plant(id: 0, commonName: "Apple", scientificName: "Something funny", imageURL: "https://bs.plantnet.org/image/o/4f56a83172d92798bf754e81e7cf2f6ec271d278", genus: "fruit", family: "possibly"))
}
