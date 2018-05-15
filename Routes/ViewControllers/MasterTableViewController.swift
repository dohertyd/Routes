//
//  MasterTableViewController.swift
//  Routes
//
//  Created by Derek Doherty on 17/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    var imageProviders = Set<RouteImageProvider>()
    var downloadsInProgress = [IndexPath:RouteImageProvider]()

    let qs = QueryService()
    var routeResults: [Route] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Routes"
        refreshRoutesFromApi()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Route", for: indexPath)
        
        if let cell = cell as? RouteTableViewCell
        {
            cell.routeName.text = routeResults[indexPath.row].name
            cell.urlStringId = routeResults[indexPath.row].imageUrl
            cell.busImageView.image = routeResults[indexPath.row].image
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


// MARK: - Table view delegate
//
extension MasterTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "MasterToDetailPageVCSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RouteTableViewCell else { return }
        if routeResults[indexPath.row].state == .Downloaded
        { return}
        
        if let imageUrl = routeResults[indexPath.row].imageUrl, let url = URL(string:imageUrl)
        {
            let ip = RouteImageProvider(url: url) {
                image in
                OperationQueue.main.addOperation {
                    self.routeResults[indexPath.row].image = image
                    self.routeResults[indexPath.row].state = .Downloaded
                    cell.updateImageViewWithImage(image)
                }
            }
            imageProviders.insert(ip)
            downloadsInProgress[indexPath] = ip
            print("Adding a provider")
        } else { // When ImagUrl is null
            cell.updateImageViewWithImage(UIImage(imageLiteralResourceName: "default_bus"))
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RouteTableViewCell else { return }
        for provider in imageProviders.filter({ $0.theUrl.absoluteString == cell.urlStringId }) {
            provider.cancel()
            imageProviders.remove(provider)
            downloadsInProgress.removeValue(forKey: indexPath)
            print("Removing a provider")
        }
    }
}
