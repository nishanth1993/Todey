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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.loadItems()
    }
    
    //MARK:- Add items when its tapped
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.alert()
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
        _ = ItemDataModel.saveContext()
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
    //Load Items
    private func loadItems() {
        guard let items = ItemDataModel.loadItems() else {
            return
        }
        self.itemArray = items
    }
    
    //Save Items
    private func saveItem(_ text: String) {
        guard let item = ItemDataModel.saveDataUsingCoreData(text) else {
            return
        }
        self.itemArray.append(item)
    }
    
    //Delete Items
    private func deleteItem(_ index: Int) {
        URLPaths.shared.context?.delete(self.itemArray[index])
        self.itemArray.remove(at: index)
        _ = ItemDataModel.saveContext()
    }
}
