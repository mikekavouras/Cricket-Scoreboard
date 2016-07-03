//
//  PointsReferenceView.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 7/2/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

class PointsReferenceView: UIView {
    
    static let NibName = "PointsReferenceView"
    
    class func xibInstance() -> PointsReferenceView {
        return NSBundle.mainBundle().loadNibNamed(NibName, owner: self, options: nil)[0] as! PointsReferenceView
    }
}