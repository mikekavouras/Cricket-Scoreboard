//
//  ScoreButton.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

protocol SwipeableButtonDelegate: AnyObject {
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
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        print("override to handle swipe gesture")
    }
    
}

@IBDesignable
class ScoreButton: SwipeableButton {
    
    @IBInspectable var value: Int = 0
    
    lazy var seed: Int = {
        return Int.random(in: 1...11)
    }()
    
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
