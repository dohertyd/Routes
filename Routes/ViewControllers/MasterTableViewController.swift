//
//  MasterTableViewController.swift
//  Routes
//
//  Created by Derek Doherty on 17/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {

    // Session with default configuration
    //
    lazy var downloadsSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    let qs = QueryService()
    var routeResults: [Route] = []
    //
    // Using this as our in memory Cache of images
    var cache:NSCache<AnyObject, AnyObject>! = NSCache()
    var refreshCtrl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Routes"
        
        refreshRoutesFromApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "MasterToDetailPageVCSegue"
        {
            let dpvc = segue.destination as! DetailPageViewController
            let index = sender as! IndexPath
            dpvc.routes = routeResults
            dpvc.routeIndex = index.row
            dpvc.cache = cache
        }
    }
}

// MARK: - Table view data source
//
extension MasterTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Route", for: indexPath) as! RouteTableViewCell
        cell.routeName.text = routeResults[indexPath.row].name
        
        if let imageUrl = routeResults[indexPath.row].imageUrl, let url = URL(string:imageUrl)
        {
            cell.updateImageViewWithImage(nil)
            if (cache.object(forKey: indexPath.row as AnyObject) != nil)
            {
                cell.updateImageViewWithImage(self.cache.object(forKey: indexPath.row as AnyObject) as? UIImage)
            } else {  // Download Image
                let task = downloadsSession.downloadTask(with: url) { location, response, error in
                    
                    if let location = location,
                        let data = try? Data(contentsOf: location),
                        error == nil,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        
                        // Only load into visible cells to avoid reuse issues
                        //
                        if  let img = UIImage(data: data) {
                            DispatchQueue.main.async {
                                if tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                                    cell.updateImageViewWithImage(img)
                                }
                                self.cache.setObject(img, forKey: indexPath.row as AnyObject)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            if tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                                cell.updateImageViewWithImage(UIImage(imageLiteralResourceName: "placeholder"))
                            }
                        }
                    }
                }
                task.resume()
            }
        } else { // When ImagUrl is null
            cell.updateImageViewWithImage(UIImage(imageLiteralResourceName: "default_bus"))
        }
        return cell
    }
}

// API Call
//
extension MasterTableViewController
{
    fileprivate func refreshRoutesFromApi() {
        routeResults.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        qs.getRoutesFromApi() { results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let results = results {
                self.routeResults = results
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: - Table view delegate overrides
//
extension MasterTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "MasterToDetailPageVCSegue", sender: indexPath)
    }
}
