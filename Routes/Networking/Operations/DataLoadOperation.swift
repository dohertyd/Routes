//
//  DataLoadOperation.swift
//  Routes
//
//  Created by Derek Doherty on 11/05/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import Foundation
import UIKit

class DataLoadOperation : AsyncOperation
{
    fileprivate let url: URL
    fileprivate let completion: ((Data?) -> ())?
    fileprivate var loadedData: Data?
    
    let downloadsSession = URLSession(configuration: .default)
    var task: URLSessionDownloadTask?
    var errorMessage = ""

    
    init(url: URL, completion: ((Data?) -> ())? = nil) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if self.isCancelled { return }
        
        task = downloadsSession.downloadTask(with: url) { location, response, error in
            if self.isCancelled { return }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let location = location,
                let data = try? Data(contentsOf: location),
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let completion = self.completion {
                
                completion(data)
                self.state = .finished
            }
            self.state = .finished
        }
        task?.resume()
    }
}
