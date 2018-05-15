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
    var currentRoute:Route!
    var ip:RouteImageProvider?
    
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
        
        busImageView.image = UIImage(imageLiteralResourceName: "default_bus")
        if let imageUrl = currentRoute.imageUrl, let url = URL(string:imageUrl)
        {
            
            ip = RouteImageProvider(url: url) {
                image in
                OperationQueue.main.addOperation {
                    self.busImageView.image = image
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ip?.cancel()
    }
    
    deinit {
        print("Deinit called for the DetailViewController Class")
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
