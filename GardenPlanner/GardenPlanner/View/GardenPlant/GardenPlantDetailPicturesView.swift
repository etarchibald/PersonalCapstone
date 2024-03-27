//
//  GardenPlantDetailPicturesView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/26/24.
//

import SwiftUI

struct GardenPlantDetailPicturesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var userPhotos: [UserPhotos]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(userPhotos.sorted(), id: \.self) { picture in
                    
                    createImage(picture.photo)
                        .resizable()
                        .frame(width: 230, height: 230)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous), style: FillStyle())
                        .shadow(radius: 5)
                        .contextMenu {
                            
                            Button("Delete", role: .destructive) {
                                withAnimation(.smooth) {
                                    userPhotos = userPhotos.filter { userPhotoToDelete in
                                        userPhotoToDelete.id.uuidString == picture.id.uuidString ? false : true
                                    }
                                    
                                    modelContext.delete(picture)
                                }
                            }
                        }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 85, bottom: 0, trailing: 85))
        }
    }
}

#Preview {
    GardenPlantDetailPicturesView(userPhotos: .constant([UserPhotos(id: UUID(), dateAdded: Date(), photo: Data())]))
}

extension GardenPlantDetailPicturesView {
    func createImage(_ value: Data) -> Image {
    #if canImport(UIKit)
        let plantImage: UIImage = UIImage(data: value) ?? UIImage()
        return Image(uiImage: plantImage)
    #elseif canImport(AppKit)
        let plantImage: NSImage = NSImage(data: value) ?? NSImage()
        return Image(nsImage: plantImage)
    #else
        return Image(systemImage: "photo")
    #endif
    }
}
