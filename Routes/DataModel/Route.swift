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
struct Route  {
    let id:String
    let accessible: Bool
    let imageUrl : String?
    let name: String
    let description: String
    let stops:[Stop]
    
    init(id: String, accessible: Bool, imageUrl: String?, name: String, description: String, stops: [Stop]) { // default struct initializer
        self.id = id
        self.accessible = accessible
        self.imageUrl = imageUrl
        self.name = name
        self.description = description
        self.stops = stops
    }
    
    var state = RouteRecordState.New
    var image = UIImage(named: "default_bus")
}

struct Stop:Decodable {
    let name: String
}

extension Route: Decodable {
    enum MyStructKeys: String, CodingKey { // declaring our keys
        case id = "id"
        case accessible = "accessible"
        case imageUrl = "imageUrl"
        case name = "name"
        case description = "description"
        case stops = "stops"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
        let accessible: Bool = try container.decode(Bool.self, forKey: .accessible) // extracting the data
        let id: String = try container.decode(String.self, forKey: .id) // extracting the data
        let imageUrl: String? = try container.decode(String?.self, forKey: .imageUrl) // extracting the data
        let name: String = try container.decode(String.self, forKey: .name) // extracting the data
        let description: String = try container.decode(String.self, forKey: .description) // extracting the data
        let stops: [Stop] = try container.decode([Stop].self, forKey: .stops) // extracting the data

        self.init(id: id, accessible: accessible, imageUrl: imageUrl, name: name, description: description, stops: stops)
    }
}

enum RouteRecordState {
    case New, Downloaded, Failed
}

