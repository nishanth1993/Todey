//
//  Item.swift
//  Todey
//
//  Created by Nishanth B S on 11/17/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class Item {
    let title: String
    var done: Bool
    
    init(_ title: String, _ done: Bool) {
        self.title = title
        self.done = done
    }
}
