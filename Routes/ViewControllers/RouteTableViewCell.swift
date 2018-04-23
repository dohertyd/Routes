//
//  RouteTableViewCell.swift
//  Routes
//
//  Created by Derek Doherty on 20/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var busImageView: UIImageView!
    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func updateImageViewWithImage(_ image: UIImage?) {
        if let image = image {
            busImageView.image = image
            busImageView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.busImageView.alpha = 1.0
                self.activityIndicator.alpha = 0
            }, completion: {
                _ in
                self.activityIndicator.stopAnimating()
            })
            
        } else { // nil!
            busImageView.image = nil
            busImageView.alpha = 1.0
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        }
    }
}
