//
//  ItemDataModel.swift
//  Todey
//
//  Created by Nishanth B S on 11/17/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import CoreData

class DataModel {
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

//MARK:- Category Data model
extension DataModel {
    //Load all categories
    static func loadCategories(_ request: NSFetchRequest<Category> = Category.fetchRequest()) -> [Category]? {
        do {
            return try URLPaths.shared.context?.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
            return nil
        }
    }
    
    //Save category
    static func saveCategory(_ text: String? = nil) -> Category? {
        if let context = URLPaths.shared.context {
            let category = Category(context: context)
            category.name = text
            return self.saveContext() ? category : nil
        }
        else {
            return nil
        }
    }
}

//MARK:- Item Data model
extension DataModel {
    
    //Load all items
    static func loadItems(_ request: NSFetchRequest<Item>, _ predicate: NSPredicate?, _ categoryName: String) -> [Item]? {
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
        if let pred = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, pred])
        }
        else {
            request.predicate = categorypredicate
        }
        do {
            return try URLPaths.shared.context?.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
            return nil
        }
    }
    
    //Load Items based on search text
    static func loadSearchResult(_ text: String, _ category: String) -> [Item]? {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        if let items = self.loadItems(request, predicate, category) {
            return items
        }
        else {
            return nil
        }
    }
    
    //Save item
    static func saveItem(_ text: String? = nil, _ category: Category? = nil) -> Item? {
        if let context = URLPaths.shared.context {
            let item = Item(context: context)
            item.title = text
            item.done = false
            item.parentCategory = category
            return self.saveContext() ? item : nil
        }
        else {
            return nil
        }
    }
}
