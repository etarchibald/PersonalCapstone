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
                            .aspectRatio(contentMode: .fill)
                            .border(Color.white, width: 3)
                            .frame(maxWidth: 130, maxHeight: 130)
                    case .failure:
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                
                Text(name)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 170, height: 280)
    }
}

#Preview {
    GardenPlantCellView(imageURl: "https://bs.plantnet.org/image/o/a42b6ba0beea54fbba5aaec0c785ac52ad3440c0", name: "Apple")
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
