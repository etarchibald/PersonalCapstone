//
//  GardenPlantDetailView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/1/24.
//

import SwiftUI

struct GardenPlantDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var showingAlert = false
    
    var plant: GardenPlant
    
    var body: some View {
        VStack {
            Text("HERE IS \(plant.name) PLANT")
            
            AsyncImage(url: URL(string: plant.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 130, maxHeight: 130)
                        .border(.black, width: 20)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            
            
            Button {
                showingAlert = true
            } label: {
                Image(systemName: "trash.fill")
                    .foregroundStyle(.red)
            }
            .alert("Are you sure you want to delete \(plant.name)?", isPresented: $showingAlert) {
                Button("Delete", role: .destructive) {
                    dismiss()
                    modelContext.delete(plant)
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

#Preview {
    GardenPlantDetailView(plant: GardenPlant(id: 103902, imageURL: "https://bs.plantnet.org/image/o/a42b6ba0beea54fbba5aaec0c785ac52ad3440c0", name: "Apple", notes: "Something about it"))
}
