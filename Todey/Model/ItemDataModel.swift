//
//  ItemDataModel.swift
//  Todey
//
//  Created by Nishanth B S on 11/17/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import CoreData

class ItemDataModel {
    
    //Load Items from core data
    static func loadItems() -> [Item]? {
        if let context = URLPaths.shared.context {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            do {
                return try context.fetch(request)
            }
            catch {
                print("Error fetching data from context \(error)")
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    //Save to core data
    static func saveDataUsingCoreData(_ text: String? = nil) -> Item? {
        if let context = URLPaths.shared.context {
            let item = Item(context: context)
            item.title = text
            item.done = false
            return self.saveContext() ? item : nil
        }
        else {
            return nil
        }
    }
    
    //Save the context
    static func saveContext() -> Bool {
        do {
            try URLPaths.shared.context?.save()
            return true
        }
        catch {
            print("Error saving data into context \(error)")
            return false
        }
    }
}
