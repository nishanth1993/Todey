//
//  RealmCategory.swift
//  Todey
//
//  Created by Nishanth Badavide Sooryanaray on 11/20/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String!
    let items = List<RealmItem>()
}
