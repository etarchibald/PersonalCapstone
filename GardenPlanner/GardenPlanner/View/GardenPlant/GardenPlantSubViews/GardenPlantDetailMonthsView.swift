//
//  GardenPlantDetailMonthsView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/28/24.
//

import SwiftUI

struct GardenPlantDetailMonthsView: View {
    
    var title: String
    var months: [String]
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            
            HStack {
                ForEach(months, id: \.self) { string in
                    Text(string.capitalized)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
        }
    }
}

#Preview {
    GardenPlantDetailMonthsView(title: "Growth Months:", months: ["Jun", "May"])
}
