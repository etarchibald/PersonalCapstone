//
//  EntryCellView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/13/24.
//

import SwiftUI

struct EntryCellView: View {
    
    var entry: Entry
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: GardenColors.dirtBrown.rawValue))
        }
    }
}

#Preview {
    EntryCellView(entry: Entry(id: UUID(), title: "Planted", body: "North Garden", date: Date()))
}
