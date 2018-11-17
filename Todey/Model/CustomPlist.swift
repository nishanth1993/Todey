//
//  CustomPlist.swift
//  Todey
//
//  Created by Nishanth B S on 11/17/18.
//  Copyright © 2018 Home. All rights reserved.
//

/*import Foundation

class CustomPlist {
    
    static func loadItems() -> [Item]? {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: URLPaths.shared.datafilePath!)
            let itemArray = try decoder.decode([Item].self, from: data)
            return itemArray
        }
        catch {
            print("Error decoding in item array \(error)")
            return nil
        }
    }
    
    static func saveDataUsingCustomPlist(_ items: [Item]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: URLPaths.shared.datafilePath!)
        }
        catch {
            print("Error encoding in item array \(error)")
        }
    }
}*/
