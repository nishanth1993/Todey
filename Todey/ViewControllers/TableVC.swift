//
//  ViewController.swift
//  Todey
//
//  Created by Nishanth B S on 11/16/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TableVC: SwipeTableViewController {
    
    fileprivate var items: Results<RealmItem>?
    //fileprivate var items = [Item]()
    var selectedCategory: RealmCategory? {
        didSet {
            self.items = RealmDataModel.loadItems(self.selectedCategory)
        }
    }
    
    /*var selectedCategory: Category? {
        didSet {
            let name = selectedCategory?.name
            self.items = DataModel.loadItems(Item.fetchRequest(), nil, name!) ?? []
        }
     }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }
    
    //MARK:- Add items when its tapped
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.alert()
    }
    
    //Delete Item
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.items?[indexPath.row], RealmDataModel.deleteItem(item) {
            
        }
    }
}

//MARK:- Search bar delegates
extension TableVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let category = self.selectedCategory, let text = searchBar.text, !text.isEmpty {
            self.items = RealmDataModel.loadSearchResult(text, category)
        }
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.items = RealmDataModel.loadItems(self.selectedCategory)
            self.tableView.reloadData()
        }
    }
}

//MARK:- Tableview Delegate and Datasource methods
extension TableVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.identifier = "ToDoItemCell"
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = self.items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            let percentage = (CGFloat(indexPath.row) / CGFloat(items!.count))
            if let color = UIColor(hexString: selectedCategory?.color ?? "#ffffff") {
                cell.backgroundColor = color.darken(byPercentage: percentage)
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.items?[indexPath.row].done = !self.items?[indexPath.row].done ?? true
        //_ = DataModel.saveContext()
        if let item = self.items?[indexPath.row], RealmDataModel.updateItem(item){
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}

//MARK:- Alert to add item to textfield
extension TableVC {
    private func alert() {
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let okAction = UIAlertAction(title: "Add Item", style: .default) { [weak self] (action) in
            guard let text = textField.text else {
                return
            }
            self?.saveItem(text)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Realm operations
extension TableVC {
    //Save Item
    private func saveItem(_ text: String) {
        if let category = self.selectedCategory, let _ = self.items, let _ = RealmDataModel.saveItem(text, category) {
            self.tableView.reloadData()
            //let indexPath = IndexPath(row: (items.count - 1), section: 0)
            //self.tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
}

/*//MARK:- Core Data operations
extension TableVC {
    //Save Item
    private func saveItem(_ text: String) {
        if let item = DataModel.saveItem(text, self.selectedCategory) {
            self.itemArray.append(item)
        }
    }
    
    //Delete Item
    private func deleteItem(_ index: Int) {
        URLPaths.shared.context?.delete(self.itemArray[index])
        self.itemArray.remove(at: index)
        _ = DataModel.saveContext()
    }
}*/
