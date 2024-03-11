//
//  NotifyViewModel.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/7/24.
//

import Foundation

class NotifyViewModel: ObservableObject {
    
    private var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func saveToFiles(_ reminders: [Notify]) {
        let archiveURL = documentDirectory.appendingPathExtension("reminders").appendingPathExtension("json")
        let encoder = JSONEncoder()
        do {
            let encode = try encoder.encode(reminders)
            try encode.write(to: archiveURL)
        } catch {
            print(error)
            print("error saving to file")
        }
    }
    
    func loadFromFiles() -> [Notify] {
        let archiveURL = documentDirectory.appendingPathExtension("reminders").appendingPathExtension("json")
        let propertyListDecoder = JSONDecoder()
        do {
            let retrivedData = try Data(contentsOf: archiveURL)
            let decoded = try propertyListDecoder.decode([Notify].self, from: retrivedData)
            return decoded
        } catch {
            print(error)
            print("error loading files")
            return []
        }
    }
}
