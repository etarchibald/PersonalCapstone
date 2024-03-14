//
//  Colors.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/5/24.
//

import Foundation
import SwiftUI

enum GardenColors: String {
    case richBlack = "#101018"
    case dirtBrown = "#7A5000"
    case plantGreen = "#018E42"
    case skyBlue = "#02B2F2"
    case whiteSmoke = "#F5F5F5"
}


extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
