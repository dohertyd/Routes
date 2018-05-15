//
//  QueryOperation.swift
//  Routes
//
//  Created by Derek Doherty on 11/05/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import Foundation

typealias QueryResult = ([Route]?, String) -> ()

class QueryOperation : AsyncOperation
{
    let defaultSession = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    private let url: URL
    private let completion: QueryResult?
    private var routes: [Route] = []
    var errorMessage = ""
    let decoder = JSONDecoder()
    
    init(url: URL, completion: @escaping QueryResult) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if self.isCancelled { return }
        task = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.task = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let completion = self.completion {
                self.updateRouteResults(data)
                DispatchQueue.main.async {
                    completion(self.routes, self.errorMessage)
                }
                self.state = .finished
            }
        }
        task?.resume()
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
