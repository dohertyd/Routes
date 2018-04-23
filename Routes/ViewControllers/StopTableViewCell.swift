//
//  StopTableViewCell.swift
//  Routes
//
//  Created by Derek Doherty on 18/04/2018.
//  Copyright © 2018 Derek Doherty. All rights reserved.
//

import UIKit

class StopTableViewCell: UITableViewCell {

    @IBOutlet weak var stopNameLabel: UILabel!
    @IBOutlet weak var topVerticalLine: UIImageView!
    @IBOutlet weak var bottomVerticalLine: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureVerticalLines(arrayPosition position:Int, withStops nrOfStops:Int) -> Void
    {
        topVerticalLine.isHidden = true
        bottomVerticalLine.isHidden = true
        if nrOfStops > 1
        {
            if position == 0 {
                topVerticalLine.isHidden = true
                bottomVerticalLine.isHidden = false
            } else if position == (nrOfStops - 1) {
                topVerticalLine.isHidden = false
                bottomVerticalLine.isHidden = true
            } else {
                topVerticalLine.isHidden = false
                bottomVerticalLine.isHidden = false
            }
        }
    }
}
