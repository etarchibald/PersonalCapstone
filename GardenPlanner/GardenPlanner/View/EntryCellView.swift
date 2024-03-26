//
//  EntryCellView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/13/24.
//

import SwiftUI
import SwiftData

struct EntryCellView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var showDeleteAlert = false
    
    @Binding var entrys: [Entry]
    
    var body: some View {
        ScrollView {
            
            ForEach(entrys.sorted(), id: \.self) { entry in
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(hex: GardenColors.plantGreen.rawValue))
                        .shadow(radius: 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(entry.title)
                                .font(.title)
                                .fontWeight(.light)
                            if !entry.body.isEmpty {
                                Text(entry.body)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        }
                    }
                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                }
                .contextMenu {
                    
                    Button("Delete", role: .destructive) {
                        withAnimation(.smooth) {
                            entrys = entrys.filter { entryToDelete in
                                entryToDelete.id.uuidString == entry.id.uuidString ? false : true
                            }
                            
                            modelContext.delete(entry)
                        }
                        
                    }
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: YourPlant.self, configurations: config)
    
    let entry = [Entry(id: UUID(), title: "Planted somthing longer with this and stuff", body: "North Garden yeah its somewhere up there yeah", date: Date()), Entry(id: UUID(), title: "Something else", body: "", date: Date())]
    
    return EntryCellView(entrys: .constant(entry))
        .modelContainer(container)
}
