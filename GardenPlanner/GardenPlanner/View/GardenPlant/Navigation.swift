//
//  Navigation.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 5/15/24.
//

import Foundation

enum PlantNavigation: String, CaseIterable {
    case plantAPIView, plantDetail
}

class Navigation: ObservableObject {
    
    @Published var navStack = [PlantNavigation]()
    
    func popToRoot() {
        navStack.removeAll()
    }
    
}
