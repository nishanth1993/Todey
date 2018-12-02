//
//  Data.swift
//  Todey
//
//  Created by Nishanth Badavide Sooryanaray on 11/20/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import RealmSwift

class RealmItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    var parentCategory = LinkingObjects(fromType: RealmCategory.self, property: "items")
}
