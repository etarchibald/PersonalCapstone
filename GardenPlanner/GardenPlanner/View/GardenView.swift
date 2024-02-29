//
//  GardenView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/27/24.
//

import SwiftUI
import SwiftData


struct GardenView: View {
    @StateObject var plantViewModel = PlantsViewModel()
    
    @Query var myGarden: [GardenPlant]
    
    var body: some View {
        NavigationStack() {
            VStack {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 20, pinnedViews: [], content: {
                            
                            ForEach(myGarden, id: \.self) { garden in
                                GardenPlantCellView(imageURl: garden.imageURL,name: garden.name)
                            }
                            
                        })
                    }
                }
                
                Spacer()
                NavigationLink {
                    PlantAPIView()
                } label: {
                    Image(systemName: "plus")
                        .frame(maxWidth: 70, maxHeight: 70)
                        .background(Color.green)
                        .foregroundStyle(Color.white)
                        .clipShape(Circle())
                }
            }
        }
    }
}

#Preview {
    GardenView()
}
