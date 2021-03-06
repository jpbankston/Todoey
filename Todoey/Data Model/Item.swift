//
//  Item.swift
//  Todoey
//
//  Created by James Bankston on 9/5/18.
//  Copyright © 2018 James Bankston. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
//    @objc dynamic var hexColor: String?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
