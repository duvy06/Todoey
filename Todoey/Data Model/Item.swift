//
//  Item.swift
//  Todoey
//
//  Created by Yvon Duvivier on 02/03/2019.
//  Copyright © 2019 Yvon Duvivier. All rights reserved.
//

import Foundation

// Codable include both Encodable, Decodable
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
