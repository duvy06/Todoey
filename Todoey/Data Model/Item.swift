//
//  Item.swift
//  Todoey
//
//  Created by Yvon Duvivier on 04/03/2019.
//  Copyright © 2019 Yvon Duvivier. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "catItems")
}
