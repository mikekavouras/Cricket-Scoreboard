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
        return NSBundle.mainBundle().loadNibNamed(NibName, owner: self, options: nil)[0] as! PlayerGameView
    }
    
    @IBOutlet var scoreButtons: [ScoreButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    weak var player: Player!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreButtons.forEach { $0.delegate = self }
        nameTextField.delegate = self
    }

    @IBAction func scoreButtonTapped(sender: ScoreButton) {
        player.hit(sender.value)
        if let state = player.board.stateForPie(sender.value) {
            updateScoreButton(sender, forState: state)
        }
        scoreLabel.text = "\(player.score)"
    }
    
    private func updateScoreButton(button: UIButton, forState state: PieState) {
        button.setTitle(state.visual(), forState: .Normal)
    }
    
    // MARK: Swipeable button delegate
    
    func handleSwipeForButton(button: SwipeableButton) {
        guard let button = button as? ScoreButton else { return }
        player.unhit(button.value)
        if let state = player.board.stateForPie(button.value) {
            updateScoreButton(button, forState: state)
        }
        scoreLabel.text = "\(player.score)"
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
