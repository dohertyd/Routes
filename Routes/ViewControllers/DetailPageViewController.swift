//
//  DetailPageViewController.swift
//  Routes
//
//  Created by Derek Doherty on 22/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import UIKit

class DetailPageViewController: UIPageViewController {

    var pageCount = 0
    var routes:[Route]!
    var cache:NSCache<AnyObject, AnyObject>!
    var routeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        pageCount = routes.count
        
        setViewControllers([routePage(forPage: routeIndex)],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    // Build a Route viewcontroller for a given page position
    //
    func routePage(forPage page:Int) -> DetailViewController
    {
        let dvc = newDetailViewController()
        let aPage = min(max(0, page), pageCount - 1)
        dvc.page = aPage
        dvc.cache = cache
        
        dvc.currentRoute = routes[page]
        return dvc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func newDetailViewController() -> DetailViewController {
        let sbvc =  UIStoryboard(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "DetailViewControllerSbId")
        return sbvc as! DetailViewController
    }

}

extension DetailPageViewController :UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController as! DetailViewController).page < pageCount - 1
        {
            return routePage(forPage: (viewController as! DetailViewController).page + 1)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (viewController as! DetailViewController).page > 0
        {
            return routePage(forPage: (viewController as! DetailViewController).page - 1)
        } else {
            return nil
        }
    }
}
