//
//  QueryService.swift
//  Routes
//
//  Created by Derek Doherty on 19/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import Foundation

// Runs a Query on the Routes API using operation Q
//
class QueryService {
    let queue = OperationQueue()
    
    func getRoutesFromApi( completion: @escaping QueryResult) {
        queue.cancelAllOperations()
        
        guard let urlComponents = URLComponents(string: "http://www.mocky.io/v2/5a0b474a3200004e08e963e5"), let url = urlComponents.url
            else { return }
        
        // The operation provides it's O/P via the completion handler
        //
        let op = QueryOperation(url: url) { routes, error in
            DispatchQueue.main.async {
                completion(routes, error)
            }
        }
        queue.addOperation(op)
    }
}
