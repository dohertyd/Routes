//
//  DetailViewController.swift
//  Routes
//
//  Created by Derek Doherty on 18/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var accessabilityIcon: UIImageView!
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var routeDescriptionLabel: UILabel!
    @IBOutlet weak var busImageView: UIImageView!
    
    var page = 0
    var cache:NSCache<AnyObject, AnyObject>!
    var currentRoute:Route!
    // Session with default configuration
    //
    lazy var downloadsSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    var task:URLSessionDownloadTask?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        theTableView.rowHeight = UITableViewAutomaticDimension
        theTableView.estimatedRowHeight = 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        accessabilityIcon.isHidden = !currentRoute.accessible
        routeNameLabel.text = currentRoute.name
        routeDescriptionLabel.text = currentRoute.description
        
        // Using our cache, if image is present for index then fine
        // if not, the image could be in the process of loading in
        // Master VC or not loaded at all , we try and download here
        // and cache if succesfull
        if let img = cache.object(forKey: page as AnyObject) as? UIImage {
            busImageView.image = img
        } else {
            busImageView.image = UIImage(imageLiteralResourceName: "default_bus")
            if let imageUrl = currentRoute.imageUrl, let url = URL(string:imageUrl)
            {
                task = downloadsSession.downloadTask(with: url) { location, response, error in
                    defer {self.task = nil}
                    if let location = location,
                        let data = try? Data(contentsOf: location),
                        error == nil,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        
                        if  let img = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.busImageView.image = img
                            }
                            self.cache.setObject(img, forKey: self.page as AnyObject)
                        }
                    }
                }
                task?.resume()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension DetailViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRoute.stops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Stop", for: indexPath) as! StopTableViewCell
        cell.stopNameLabel.text = currentRoute.stops[indexPath.row].name
        cell.configureVerticalLines(arrayPosition: indexPath.row, withStops: currentRoute.stops.count)
        return cell
    }
}
