//
//  ViewController.swift
//  Todey
//
//  Created by Nishanth B S on 11/16/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import CoreData

class TableVC: UITableViewController {
    
    fileprivate var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            let name = selectedCategory?.name
            self.itemArray = DataModel.loadItems(Item.fetchRequest(), nil, name!) ?? []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    //MARK:- Add items when its tapped
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.alert()
    }
}

//MARK:- Search bar delegates
extension TableVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let name = self.selectedCategory?.name, let text = searchBar.text, !text.isEmpty {
            self.itemArray = DataModel.loadSearchResult(text, name) ?? []
        }
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let name = self.selectedCategory?.name, searchText == "" {
            self.itemArray = DataModel.loadItems(Item.fetchRequest(), nil, name) ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK:- Tableview Delegate and Datasource methods
extension TableVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = self.itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemArray[indexPath.row].done = !self.itemArray[indexPath.row].done
        _ = DataModel.saveContext()
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

//MARK:- Alert to add item to textfield
extension TableVC {
    private func alert() {
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let okAction = UIAlertAction(title: "Add Item", style: .default) { [weak self] (action) in
            guard let text = textField.text, let strongSelf = self else {
                return
            }
            self?.saveItem(text)
            let indexPath = IndexPath(row: (strongSelf.itemArray.count - 1), section: 0)
            strongSelf.tableView.insertRows(at: [indexPath], with: .fade)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Core Data operations
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
}
