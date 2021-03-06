//
//  ScoreButton.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

protocol SwipeableButtonDelegate: class {
    func handleSwipeForButton(_ button: SwipeableButton)
}

@IBDesignable
class SwipeableButton: UIButton {

    weak var delegate: SwipeableButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SwipeableButton.handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        addGestureRecognizer(swipeGesture)
    }
    
    func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
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
    
    override func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        delegate?.handleSwipeForButton(self)
    }
}
