//
//  PlayerGameView.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

class PlayerGameView: UIView, SwipeableButtonDelegate, UITextFieldDelegate {
    
    static let NibName = "PlayerGameView"
    
    @IBOutlet weak var nameTextField: UITextField!
    
    class func xibInstance() -> PlayerGameView {
        return Bundle.main.loadNibNamed(NibName, owner: self, options: nil)![0] as! PlayerGameView
    }
    
    @IBOutlet var scoreButtons: [ScoreButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    weak var player: Player!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreButtons.forEach { $0.delegate = self }
        nameTextField.delegate = self
    }

    @IBAction func scoreButtonTapped(_ button: ScoreButton) {
        player.hit(button.value)
        guard let state = player.board.stateForPie(button.value) else { return }
        
        updateScoreButton(button, forState: state)
        let scoreChanged = scoreLabel.text! != "\(player.score)"
        scoreLabel.text = "\(player.score)"
        
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        UIView.animate(withDuration: 0.2) {
            button.backgroundColor = .darkGreen
        }
        
        if scoreChanged {
            let label = UILabel(frame: CGRect.zero)
            label.text = "+ \(button.value)"
            label.frame = button.frame
            label.frame.origin.y -= 60
            label.textColor = UIColor.yellow
            label.font = UIFont(name: "Chalkduster", size: 32)
            label.textAlignment = .center
            
            addSubview(label)
            
            UIView.animate(withDuration: 1.2, delay: 0.2, options: .curveEaseOut, animations: {
                label.frame.origin.y -= 100
                label.alpha = 0.0
            }) { done in
                label.removeFromSuperview()
            }
        }
    }
    
    fileprivate func updateScoreButton(_ button: UIButton, forState state: PieState) {
        button.setTitle(state.visual(), for: UIControlState())
    }
    
    // MARK: Swipeable button delegate
    
    func handleSwipeForButton(_ button: SwipeableButton) {
        guard let button = button as? ScoreButton else { return }
        player.unhit(button.value)
        if let state = player.board.stateForPie(button.value) {
            updateScoreButton(button, forState: state)
        }
        
        let scoreChanged = scoreLabel.text! != "\(player.score)"
        scoreLabel.text = "\(player.score)"
        
        button.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = .darkGreen
        }
        
        if scoreChanged {
            let label = UILabel(frame: CGRect.zero)
            label.text = "- \(button.value)"
            label.frame = button.frame
            label.frame.origin.y -= 60
            label.textColor = UIColor.red.withAlphaComponent(0.6)
            label.font = UIFont(name: "Chalkduster", size: 32)
            label.textAlignment = .center
            
            addSubview(label)
            
            UIView.animate(withDuration: 1.2, delay: 0.2, options: .curveEaseOut, animations: {
                label.frame.origin.y -= 100
                label.alpha = 0.0
            }) { done in
                label.removeFromSuperview()
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
