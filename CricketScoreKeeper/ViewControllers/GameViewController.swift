//
//  ViewController.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import SnapKit
import SwiftConfettiView

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
        let containerView = UIView()
        view.addSubview(containerView)
        
        containerView.alpha = 0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let overlayView = UIView()
        containerView.addSubview(overlayView)
        
        overlayView.backgroundColor = .black.withAlphaComponent(0.7)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        confettiView.intensity = 0.8
        containerView.addSubview(confettiView)
        confettiView.bounds = view.bounds
        confettiView.startConfetti()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        let playerNameLabel = UILabel()
        playerNameLabel.adjustsFontSizeToFitWidth = true
        playerNameLabel.text = player.name
        playerNameLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 50)
        playerNameLabel.textColor = .white
        playerNameLabel.textAlignment = .center
        stackView.addArrangedSubview(playerNameLabel)
        
        let winsLabel = UILabel()
        winsLabel.adjustsFontSizeToFitWidth = true
        winsLabel.text = "wins!"
        winsLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 34)
        winsLabel.textColor = .white
        winsLabel.textAlignment = .center
        
        stackView.addArrangedSubview(winsLabel)
        containerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -80).isActive = true
        
        let newGameButton = UIButton(type: .custom)
        newGameButton.alpha = 0.0
        newGameButton.setTitle("Start new game", for: .normal)
        newGameButton.setTitleColor(.white, for: .normal)
        newGameButton.transform = newGameButton.transform.scaledBy(x: 0.7, y: 0.7)
        newGameButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        containerView.addSubview(newGameButton)
        
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        newGameButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 100).isActive = true
        newGameButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        newGameButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        newGameButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        UIView.animate(withDuration: 1.2) {
            containerView.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
                newGameButton.alpha = 1.0
                newGameButton.transform = .identity
            }, completion: nil)
        }

    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
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
        let player1GameView = Player.newGameView()
        let player2GameView = Player.newGameView()
        
        view.addSubview(player1GameView)
        view.addSubview(player2GameView)
        view.addSubview(scoreReferenceView)
        
        scoreReferenceView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        player1GameView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(16.0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalTo(scoreReferenceView.snp.left)
        }
        
        player2GameView.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-16.0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(scoreReferenceView.snp.right)
        }
        
        guard let player1 = stateManager.game.players.first,
            let player2 = stateManager.game.players.last else { return }
        
        player1GameView.player = player1
        player2GameView.player = player2
    }
    
    @objc func newGameButtonTapped() {
        self.shouldBeginNewGameHandler?()
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
