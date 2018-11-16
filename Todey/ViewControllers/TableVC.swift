//
//  ViewController.swift
//  Todey
//
//  Created by Nishanth B S on 11/16/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    fileprivate var itemArray = ["Horizon Zero Dawn", "God of War", "Assassins Creed Origins", "Fallout 4", "Red Dead Redemption"]
    fileprivate let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        if let items = self.defaults.array(forKey: "ToDoListArray") as? [String] {
            self.itemArray = items
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
        cell.textLabel?.text = self.itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
            strongSelf.itemArray.append(text)
            strongSelf.defaults.set(strongSelf.itemArray, forKey: "ToDoListArray")
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
