//
//  CategoryTableVC.swift
//  Todey
//
//  Created by Nishanth B S on 11/17/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class CategoryTableVC: UITableViewController {
    
    fileprivate var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.categoryArray = DataModel.loadCategories() ?? []
    }
    
    //MARK:- Add button tapped
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.alert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TableVC, let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categoryArray[indexPath.row]
        }
    }
}

//MARK:- Tableview delegate and datasource methods
extension CategoryTableVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        let category = self.categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}

//MARK:- Alert to add item to textfield
extension CategoryTableVC {
    private func alert() {
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let okAction = UIAlertAction(title: "Add category", style: .default) { [weak self] (action) in
            guard let text = textField.text, let strongSelf = self else {
                return
            }
            self?.saveItem(text)
            let indexPath = IndexPath(row: (strongSelf.categoryArray.count - 1), section: 0)
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
extension CategoryTableVC {
    //Save Category
    private func saveItem(_ text: String) {
        if let category = DataModel.saveCategory(text) {
            self.categoryArray.append(category)
        }
    }
    
    //Delete Category
    private func deleteItem(_ index: Int) {
        URLPaths.shared.context?.delete(self.categoryArray[index])
        self.categoryArray.remove(at: index)
        _ = DataModel.saveContext()
    }
}
