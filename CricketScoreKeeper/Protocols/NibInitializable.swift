//
//  NibInitializable.swift
//  CricketScoreKeeper
//
//  Created by Michael Kavouras on 12/31/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

public protocol NibInitializable: class {
    static var nibName: String { get }
}

extension NibInitializable where Self: UIView {
    public static func initFromNib() -> Self {
        let nib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        return nib!.first as! Self
    }
}
