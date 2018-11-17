//
//  Paths.swift
//  Todey
//
//  Created by Nishanth B S on 11/17/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class URLPaths {
    
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    static let shared = URLPaths()
}
