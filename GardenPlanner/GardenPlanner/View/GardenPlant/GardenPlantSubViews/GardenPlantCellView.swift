//
//  GardenPlantCellView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/28/24.
//

import SwiftUI

struct GardenPlantCellView: View {
    
    var imageURl: String
    var name: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: GardenColors.plantGreen.rawValue), Color(hex: GardenColors.skyBlue.rawValue)]), startPoint: .bottom, endPoint: .top))
                .shadow(radius: 10)
            
            VStack {
                plantPhotoView(image: imageURl)
                
                Text(name)
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                    .padding(.horizontal, 10)
            }
        }
        .frame(width: 170, height: 280)
        .shadow(radius: 5)
    }
    
    func plantPhotoView(image: String) -> some View {
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous), style: FillStyle())
                    .shadow(radius: 5)
            case .failure:
                Image(systemName: "leaf.fill")
                    .foregroundStyle(.white)
                    .font(.system(size: 60))
                    .padding()
            @unknown default:
                EmptyView()
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    GardenPlantCellView(imageURl: "https://bs.plantnet.org/image/o/a42b6ba0beea54fbba5aaec0c785ac52ad3440c0", name: "Apple")
}
