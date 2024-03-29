//
//  PlantPictureScrollView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/26/24.
//

import SwiftUI

struct PlantPictureScrollView: View {
    
    var pictures: [APIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 230) {
                ForEach(pictures, id: \.self) { picture in
                    GeometryReader { geometry in
                        AsyncImage(url: URL(string: picture.imageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 230, height: 230)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous), style: FillStyle())
                                    .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).midX) - 85) / -20), axis: (x: 0, y: 1.0, z: 0))
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 85, bottom: 0, trailing: 300))
        }
    }
}

#Preview {
    PlantPictureScrollView(pictures: [
        APIImage(imageURL: "https://bs.plantnet.org/image/o/75ca67fe56e36b3240703e037c4a7ff3893ce73c"),
        APIImage(imageURL: "https://bs.plantnet.org/image/o/67a5eba96afc5b309095c2a4a9955c7a84d5715f"),
        APIImage(imageURL: "https://bs.plantnet.org/image/o/0bd32c061a5b952934b3e6cf0f7eab89cf3f4356"),
        APIImage(imageURL: "https://bs.plantnet.org/image/o/3e02cdea04b87a3abc916874467fc56256e9e832"),
        APIImage(imageURL: "https://bs.plantnet.org/image/o/016462f21e5c51f2e5858b8ae1ff1fb42ca7c4a6")])
}
