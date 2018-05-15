//
//  RouteImageProvider.swift
//  Routes
//
//  Created by Derek Doherty on 11/05/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import Foundation
import UIKit

class RouteImageProvider
{
    fileprivate let operationQueue = OperationQueue()
//    let tiltShiftImage: TiltShiftImage
    let theUrl: URL
    
    init(url: URL, completion: @escaping (UIImage?) -> ()) {
//        self.tiltShiftImage = tiltShiftImage
//        let url = Bundle.main.url(forResource: tiltShiftImage.imageName, withExtension: "compressed")!
        self.theUrl = url
        
        // Create the operations
        let dataLoad = DataLoadOperation(url: url) { data in
            if let data = data {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }
//        let imageDecompress = ImageDecompressionOperation(data: nil)
//        let tiltShift = TiltShiftOperation(image: nil)
//        let filterOutput = ImageFilterOutputOperation(completion: completion)
//        let operations = [dataLoad, imageDecompress, tiltShift, filterOutput]
        let operations = [dataLoad]

        // Add dependencies
//        imageDecompress.addDependency(dataLoad)
//        tiltShift.addDependency(imageDecompress)
//        filterOutput.addDependency(tiltShift)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension RouteImageProvider: Hashable {
    var hashValue: Int {
        return (theUrl.absoluteString).hashValue
    }
}

func ==(lhs: RouteImageProvider, rhs: RouteImageProvider) -> Bool {
    return lhs.theUrl.absoluteString == rhs.theUrl.absoluteString
}






