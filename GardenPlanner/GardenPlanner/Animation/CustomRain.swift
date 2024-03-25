//
//  CustomRain.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/22/24.
//

import Foundation
import Vortex

extension VortexSystem {
    
    public static let customSlowRain: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            position: [0.5, 0],
            shape: .box(width: 1.2, height: 0),
            birthRate: 150,
            lifespan: 5,
            speed: 0.2,
            speedVariation: 0.5,
            angle: .degrees(180),
            colors: .random(
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.6),
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.5),
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.4)
            ),
            size: 0.09,
            sizeVariation: 0.05,
            stretchFactor: 20
        )
    }()
}
