//
//  ViewController.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import SnapKit

class GameViewController: UIViewController, UITextFieldDelegate {
    
    let game: Game!
    
    init(game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.feltGreenColor()
        buildPlayerViews()
    }
    
    private func buildPlayerViews() {
        let player1GameView = Player.gameView
        let player2GameView = Player.gameView
        let scoreReferenceView = PointsReferenceView.xibInstance()
        
        view.addSubview(scoreReferenceView)
        view.addSubview(player1GameView)
        view.addSubview(player2GameView)
        
        scoreReferenceView.snp_makeConstraints { (make) in
            make.width.equalTo(70)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        player1GameView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(16.0)
            make.top.equalTo(self.view).offset(20.0)
            make.bottom.equalTo(self.view)
            make.right.equalTo(scoreReferenceView.snp_left)
        }
        
        player2GameView.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-16.0)
            make.top.equalTo(self.view).offset(20.0)
            make.bottom.equalTo(self.view)
            make.left.equalTo(scoreReferenceView.snp_right)
        }
        
        guard let player1 = game.players.first,
            player2 = game.players.last else { return }
        
        player1GameView.player = player1
        player2GameView.player = player2
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

