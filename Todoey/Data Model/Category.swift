//
//  Category.swift
//  Todoey
//
//  Created by Yvon Duvivier on 04/03/2019.
//  Copyright © 2019 Yvon Duvivier. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let catItems = List<Item>()
}
