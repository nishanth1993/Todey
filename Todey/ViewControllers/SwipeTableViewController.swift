//
//  SwipeTableViewController.swift
//  Todey
//
//  Created by Nishanth B S on 12/2/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var identifier: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    //MARK:- Swipe cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    //Swipe cell action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    //Swipe cell action options
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    //MARK:- Update model
    func updateModel(at indexPath: IndexPath) {
        //Update model at indexpath
    }
}
