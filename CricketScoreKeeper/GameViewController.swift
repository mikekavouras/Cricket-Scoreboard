//
//  ViewController.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import SnapKit
import SpriteKit

class GameViewController: UIViewController {
    
    let game: Game!
    let winnerView = SKView()
    var shouldBeginNewGameHandler: (() -> Void)?
    
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
    
    func displayWinner(player: Player) {
        print("player wins!")
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            let noAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: { (_) in
                self.shouldBeginNewGameHandler?()
            })
            
            let alert = UIAlertController(title: "New Game?", message: "Do you want to start a new game?", preferredStyle: .Alert)
            alert.addAction(noAction)
            alert.addAction(yesAction)
            
            presentViewController(alert, animated: true, completion: nil)
        }
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
            make.top.equalTo(self.view).offset(28.0)
            make.bottom.equalTo(self.view)
        }
        
        player1GameView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(16.0)
            make.top.equalTo(self.view).offset(28.0)
            make.bottom.equalTo(self.view)
            make.right.equalTo(scoreReferenceView.snp_left)
        }
        
        player2GameView.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-16.0)
            make.top.equalTo(self.view).offset(28.0)
            make.bottom.equalTo(self.view)
            make.left.equalTo(scoreReferenceView.snp_right)
        }
        
        guard let player1 = game.players.first,
            player2 = game.players.last else { return }
        
        player1GameView.player = player1
        player2GameView.player = player2
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

