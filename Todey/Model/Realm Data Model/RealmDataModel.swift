//
//  RealmDataModel.swift
//  Todey
//
//  Created by Nishanth Badavide Sooryanaray on 11/20/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import RealmSwift

//MARK:- Category Data Model
class RealmDataModel {
    
    //Save category to realm
    static func saveCategory(_ text: String) -> RealmCategory? {
        let category = RealmCategory()
        category.name = text
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(category)
            }
            return category
        }
        catch {
            print("Error saving data into realm \(error)")
            return nil
        }
    }
    
    //Load category from realm
    static func getCategories() -> Results<RealmCategory>? {
        do {
            let realm = try Realm()
            return realm.objects(RealmCategory.self)
        }
        catch {
            print("Error getting data from realm \(error)")
            return nil
        }
    }
}

//MARK:- Item Data Model
extension RealmDataModel {
    //Save item
    static func saveItem(_ text: String, _ category: RealmCategory) -> RealmItem? {
        let item = RealmItem()
        item.title = text
        item.done = false
        category.items.append(item)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(item)
            }
            return item
        }
        catch {
            print("Error saving data into realm \(error)")
            return nil
        }
    }
    
    //Load all items
    static func loadItems(_ categoryName: RealmCategory?) -> Results<RealmItem>? {
        if let items = categoryName?.items.sorted(byKeyPath: "title", ascending: true) {
            return items
        }
        else {
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
    
    //Update item
    static func updateItem(_ item: RealmItem) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                item.done = !item.done
            }
            return true
        }
        catch {
            print("Error saving data into realm \(error)")
            return false
        }
    }
    
    //Delete item
    static func deleteItem(_ item: RealmItem) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(item)
            }
            return true
        }
        catch {
            print("Error saving data into realm \(error)")
            return false
        }
    }
}
