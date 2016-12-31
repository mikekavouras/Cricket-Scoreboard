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
        if let state = player.board.stateForPie(button.value) {
            updateScoreButton(button, forState: state)
        }
        scoreLabel.text = "\(player.score)"
        
        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = .darkGreen
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
        scoreLabel.text = "\(player.score)"
        
        button.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = .darkGreen
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
