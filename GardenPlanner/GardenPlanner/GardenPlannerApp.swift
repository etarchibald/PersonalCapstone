//
//  GardenPlannerApp.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import SwiftUI
import SwiftData

@main
struct GardenPlannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    var plantModelContainer: ModelContainer
//    var notifyModelContainer: ModelContainer
//    
//    init() {
//        do {
//            plantModelContainer = try ModelContainer(for: GardenPlant.self)
//            notifyModelContainer = try ModelContainer(for: Notify.self)
//        } catch {
//            fatalError("Failed to load model")
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
            GardenView()
                .modelContainer(for: GardenPlant.self)
        }
    }
}
