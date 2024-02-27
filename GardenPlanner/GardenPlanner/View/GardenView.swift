//
//  GardenView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/27/24.
//

import SwiftUI

struct GardenView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                
                
                
                
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
