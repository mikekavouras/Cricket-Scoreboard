//
//  ViewController.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import SnapKit

class GameViewController: UIViewController {
    
    private let stateManager: GameStateManager!
    var shouldBeginNewGameHandler: (() -> Void)?
    fileprivate let scoreReferenceView = PointsReferenceView(frame: .zero)
    
    init(stateManager: GameStateManager) {
        self.stateManager = stateManager
        super.init(nibName: nil, bundle: nil)
        stateManager.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.feltGreen
        buildPlayerViews()
    }
    
    func displayWinner(_ player: Player) {
        print("player wins!")
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                self.shouldBeginNewGameHandler?()
            })
            
            let alert = UIAlertController(title: "New Game?", message: "Do you want to start a new game?", preferredStyle: .alert)
            alert.addAction(noAction)
            alert.addAction(yesAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func buildPlayerViews() {
        let player1GameView = PlayerGameView.initFromNib()
        let player2GameView = PlayerGameView.initFromNib()
        
        view.addSubview(player1GameView)
        view.addSubview(player2GameView)
        view.addSubview(scoreReferenceView)
        
        scoreReferenceView.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(28.0)
            make.bottom.equalTo(view)
        }
        
        player1GameView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(16.0)
            make.top.equalTo(view).offset(28.0)
            make.bottom.equalTo(view)
            make.right.equalTo(scoreReferenceView.snp.left)
        }
        
        player2GameView.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-16.0)
            make.top.equalTo(view).offset(28.0)
            make.bottom.equalTo(view)
            make.left.equalTo(scoreReferenceView.snp.right)
        }
        
        guard let player1 = stateManager.game.players.first,
            let player2 = stateManager.game.players.last else { return }
        
        player1GameView.player = player1
        player2GameView.player = player2
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}


// MARK: - Game state manager delegate

extension GameViewController: GameStateManagerDelegate {
    func gameStateDidChange(manager: GameStateManager) {
        scoreReferenceView.render(manager.competitivePieStates)
    }
}
