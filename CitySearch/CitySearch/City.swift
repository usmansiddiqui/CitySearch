//
//  City.swift
//  CitySearch
//
//  Created by Usman Siddiqui on 10/19/18.
//  Copyright © 2018 Usman_Siddiqui. All rights reserved.
//

import Foundation

struct City: Codable {
    var country: String
    var name: String
    var id: UInt
    var coord: [String: Double]
    
    
    enum CodingKeys : String, CodingKey {
        case country
        case name
        case id = "_id"
        case coord
    }
    
}
