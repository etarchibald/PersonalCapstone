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
                .fill(Color(hex: "#228B22"))
                .shadow(radius: 10)
            
            VStack {
                AsyncImage(url: URL(string: imageURl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .border(Color.white, width: 3)
                            .frame(width: 150, height: 150)
                    case .failure:
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                
                Text(name)
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
        .frame(width: 170, height: 280)
    }
}

#Preview {
    GardenPlantCellView(imageURl: "https://bs.plantnet.org/image/o/a42b6ba0beea54fbba5aaec0c785ac52ad3440c0", name: "Apple")
}
