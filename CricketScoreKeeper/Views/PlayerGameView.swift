//
//  PlayerGameView.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

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
        
        button.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        UIView.animate(withDuration: 0.2) {
            button.backgroundColor = .darkGreen
        }
        
        if scoreChanged {
            showScoreChangedUI(direction: .add, button: button)
        }
    }
    
    fileprivate func updateScoreButton(_ button: UIButton, forState state: PieState) {
        button.setTitle(state.visual(), for: UIControlState())
    }
    
    fileprivate func showScoreChangedUI(direction: MoveDirection, button: UIButton) {
        let goodEmoji = ["😎", "😝", "👍", "🙌", "💪", "✨", "🏅"]
        let badEmoji = ["😫", "👎", "🙈", "😵"]
        let emoji = direction == .add ? goodEmoji : badEmoji
        
        let label = UILabel(frame: CGRect.zero)
        let randomIndex = Int(arc4random_uniform(UInt32(emoji.count)))
        
        addSubview(label)
        label.textColor = UIColor.yellow
        label.font = UIFont.systemFont(ofSize: 32.0)
        label.textAlignment = .center
        label.frame = button.frame
        label.text = emoji[randomIndex]
        
        UIView.animate(withDuration: 1.2, delay: 0.1, options: .curveEaseOut, animations: {
            label.frame.origin.y -= 100
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
        
        button.backgroundColor = UIColor.negative
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = .darkGreen
        }
        
        if scoreChanged {
            showScoreChangedUI(direction: .subtract, button: button)
        }
    }
}


// MARK: - UITextFieldDelegate

extension PlayerGameView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
