//
//  PlantAPIView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import SwiftUI

struct PlantAPIView: View {
    @StateObject var plantsViewModel = PlantsViewModel()
    @State private var searchText = ""
    
    var dummyPlants = PlantArray.dummyArrayOfPlants
    
    var body: some View {
        NavigationStack {
            Spacer()
                .searchable(text: $searchText)
                .onSubmit(of: .search) {
                    fetchPlants()
                }
            Spacer()
            ScrollView {
                ForEach(plantsViewModel.plants) { plant in
                    NavigationLink {
                        ContentView()
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: plant.imageURL ?? "")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 300, maxHeight: 100)
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                // Since the AsyncImagePhase enum isn't frozen,
                                // we need to add this currently unused fallback
                                // to handle any new cases that might be added
                                // in the future:
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
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    func fetchPlants() {
        Task {
            await plantsViewModel.fetchPlants(using: searchText)
        }
    }
}

#Preview {
    PlantAPIView()
}
