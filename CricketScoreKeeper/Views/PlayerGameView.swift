//
//  PlayerGameView.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerGameView: UIView, NibInitializable {
    
    static var nibName: String = "PlayerGameView"
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var scoreButtons: [ScoreButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    weak var player: Player!
    
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreButtons.forEach { $0.delegate = self }
        nameTextField.delegate = self
    }
    
    
    // MARK: - Actions

    @IBAction func scoreButtonTapped(_ button: ScoreButton) {
        player.hit(button.value)
        
        guard let state = player.board.stateForPie(button.value) else { return }
        
        updateScoreButton(button, forState: state)
        
        let scoreChanged = scoreLabel.text! != "\(player.score)"
        scoreLabel.text = "\(player.score)"
        
        let isClosed = player.hasClosed(button.value)
        let darkColor: UIColor = isClosed ? UIColor.black.withAlphaComponent(0.35) : UIColor.black.withAlphaComponent(0.15)
        let resolveColor: UIColor = isClosed ? UIColor.black.withAlphaComponent(0.15) : UIColor.darkGreen
        
        button.backgroundColor = darkColor
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: {
            button.backgroundColor = resolveColor
        }, completion: nil)
        
        if scoreChanged {
            showScoreChangedUI(direction: .add, value: button.value)
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

        }
        
        if isClosed && !scoreChanged {
            UIImpactFeedbackGenerator(style: .rigid ).impactOccurred()
        }
        
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }
        
        
    }
    
    fileprivate func updateScoreButton(_ button: ScoreButton, forState state: PieState) {
        // Update pie state
        if let imageBase = state.visualBase() {
            let image = UIImage(named: "\(imageBase)-\(button.seed)")
            button.setImage(image, for: UIControl.State())
        } else {
            button.setImage(nil, for: UIControl.State())
        }
        
        
    }
    
    fileprivate func showScoreChangedUI(direction: MoveDirection, value: Int) {
        let label = UILabel(frame: CGRect.zero)
        let symbol = direction == .add ? "+" : "-"
        
        addSubview(label)
        label.textColor = UIColor.white
        label.font = UIFont(name: "Chalkboard SE", size: 28.0)
        label.textAlignment = .center
        label.frame = scoreLabel.frame
        label.frame.origin.y -= 40
        label.text = "\(symbol) \(value)"
        
        UIView.animate(withDuration: 0.2, animations: {
            self.scoreLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { done in
            UIView.animate(withDuration: 0.2) {
                self.scoreLabel.transform = CGAffineTransform.identity
            }
        }
        
        UIView.animate(withDuration: 1.2, animations: {
            label.frame.origin.y -= 100
            label.transform = label.transform.scaledBy(x: 2.4, y: 2.4)
            label.alpha = 0.0
        }) { done in
            label.removeFromSuperview()
        }
    }
    
}


// MARK: - Swipeable button delegate

extension PlayerGameView: SwipeableButtonDelegate {
    func handleSwipeForButton(_ button: SwipeableButton) {
        guard let button = button as? ScoreButton else { return }
        
        player.unhit(button.value)
        
        guard let state = player.board.stateForPie(button.value) else { return }
        
        updateScoreButton(button, forState: state)
        
        let scoreChanged = scoreLabel.text! != "\(player.score)"
        scoreLabel.text = "\(player.score)"
        
        let isClosed = player.hasClosed(button.value)
        let resolveColor: UIColor = isClosed ? UIColor.black.withAlphaComponent(0.15) : UIColor.darkGreen
        
        button.backgroundColor = UIColor.negative
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = resolveColor
        }
        
        if scoreChanged {
            showScoreChangedUI(direction: .subtract, value: button.value)
        }
    }
}


// MARK: - UITextFieldDelegate

extension PlayerGameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        player.name = textField.text!
    }
}
