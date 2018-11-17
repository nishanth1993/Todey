//
//  ViewController.swift
//  Todey
//
//  Created by Nishanth B S on 11/16/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    fileprivate let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    fileprivate var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.loadItems()
    }
    
    private func loadItems() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: self.datafilePath!)
            self.itemArray = try decoder.decode([Item].self, from: data)
        }
        catch {
            print("Error decoding in item array \(error)")
        }
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
        self.saveDataUsingCustomPlist()
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
            strongSelf.itemArray.append(Item(text, false))
            strongSelf.saveDataUsingCustomPlist()
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
    
    func saveDataUsingCustomPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.datafilePath!)
        }
        catch {
            print("Error encoding in item array \(error)")
        }
    }
}
