//
//  PicturesSectionView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/18/24.
//

import SwiftUI

struct PicturesSectionView: View {
    
    var title: String
    var pictures: [APIImage]
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(Color(hex: GardenColors.plantGreen.rawValue))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
        PlantPictureScrollView(pictures: pictures)
            .frame(height: 230, alignment: .center)
    }
}

#Preview {
    PicturesSectionView(title: "Flowers:", pictures: [])
}
