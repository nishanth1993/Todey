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
        do {
            let realm = try Realm()
            try realm.write {
                category.name = text
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
            print("Error fetching data from realm \(error)")
            return nil
        }
    }
    
    //Delete category
    static func deleteCategory(_ category: RealmCategory) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(category)
            }
            return true
        }
        catch {
            print("Error saving data from realm \(error)")
            return false
        }
    }
}

//MARK:- Item Data Model
extension RealmDataModel {
    //Save item
    static func saveItem(_ text: String, _ category: RealmCategory) -> RealmItem? {
        let item = RealmItem()
        do {
            let realm = try Realm()
            try realm.write {
                item.title = text
                item.done = false
                item.date = Date()
                category.items.append(item)
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
    static func loadSearchResult(_ text: String, _ category: RealmCategory) -> Results<RealmItem>? {
        let items = category.items.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "date", ascending: true)
        return items
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
            print("Error updating data into realm \(error)")
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
            print("Error deleting data from realm \(error)")
            return false
        }
    }
}
