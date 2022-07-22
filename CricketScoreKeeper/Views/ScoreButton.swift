//
//  ScoreButton.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

protocol ScoreButtonDelegate: AnyObject {
    func handleClearActionForButton(_ button: ScoreButton)
    func handleUndoActionForButton(_ button: ScoreButton)
}

@IBDesignable
class ScoreButton: UIButton {
    weak var delegate: ScoreButtonDelegate?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        setupUndoInteraction()
        setupMenuInteraction()
    }
    
    private func setupUndoInteraction() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        addGestureRecognizer(swipeGesture)
    }
    
    private func setupMenuInteraction() {
        let menuItems = [
            UIAction(title: "Clear", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off, handler: { [weak self] action in
                self?.delegate?.handleClearActionForButton(self!)
            }),
            UIAction(title: "Undo", image: UIImage(systemName: "arrow.uturn.left"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off, handler: { [weak self] action in
                self?.delegate?.handleUndoActionForButton(self!)
            })
        ]
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: menuItems)
        self.menu = menu
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        delegate?.handleUndoActionForButton(self)
    }
}
