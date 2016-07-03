//
//  ScoreButton.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

protocol SwipeableButtonDelegate: class {
    func handleSwipeForButton(button: SwipeableButton)
}

@IBDesignable
class SwipeableButton: UIButton {

    weak var delegate: SwipeableButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SwipeableButton.handleSwipeGesture(_:)))
        swipeGesture.direction = .Left
        addGestureRecognizer(swipeGesture)
    }
    
    func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        print("override to handle swipe gesture")
    }
    
}

@IBDesignable
class ScoreButton: SwipeableButton {
    
    @IBInspectable var value: Int = 0
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        delegate?.handleSwipeForButton(self)
    }
}
