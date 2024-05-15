//
//  RootView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 5/15/24.
//

import SwiftUI

struct RootView: View {
    
    @StateObject var navigation = Navigation()
    
    var body: some View {
        NavigationStack(path: $navigation.navStack) {
            GardenView()
                .navigationDestination(for: PlantNavigation.self) { _ in
                    PlantAPIView()
                }
        }
        .environmentObject(navigation)
    }
}

#Preview {
    RootView()
}
