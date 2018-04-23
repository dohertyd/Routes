//
//  QueryService.swift
//  Routes
//
//  Created by Derek Doherty on 19/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import Foundation

// Runs a Query on the Routes API using URLSession dataTask and stores in an array of Routes
//
class QueryService {
    typealias QueryResult = ([Route]?, String) -> ()
    var routes:[Route] = []
    var errorMessage = ""
    
    // Session with default configuration
    //
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    var dataTask: URLSessionDataTask?
    let decoder = JSONDecoder()
    
    //
    //
    func getRoutesFromApi (completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        guard let urlComponents = URLComponents(string: "http://www.mocky.io/v2/5a0b474a3200004e08e963e5"), let url = urlComponents.url
            else { return }
        
        dataTask = session.dataTask(with: url) { data, response, error in
            defer {self.dataTask = nil}
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                      let response =  response as? HTTPURLResponse,
                      response.statusCode == 200
            {
                self.updateRouteResults(data)
                DispatchQueue.main.async {
                    completion(self.routes, self.errorMessage)
                }
            }
        }
        dataTask?.resume()
    }
    
    fileprivate func updateRouteResults(_ data: Data) {
        routes.removeAll()
        do {
            let list = try decoder.decode([Route].self, from: data)
            routes = list.sorted{$0.name < $1.name}
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            return
        }
    }
}
