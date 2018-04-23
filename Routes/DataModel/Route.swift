//
//  Route.swift
//  Routes
//
//  Created by Derek Doherty on 19/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import Foundation
import UIKit

// Using Swift 4 Decodable to deserialize JSON data coming from API
//
struct Route : Decodable {
    let id:String
    let accessible: Bool
    let imageUrl : String?
    let name: String
    let description: String
    let stops:[Stop]
    
}

struct Stop:Decodable {
    let name: String
}
