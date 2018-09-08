//
//  Category.swift
//  Todoey
//
//  Created by James Bankston on 9/5/18.
//  Copyright © 2018 James Bankston. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColor: String?
    let items = List<Item>()
}
