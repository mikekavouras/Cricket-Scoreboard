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
    private var stateManager: GameStateManager!
    var shouldBeginNewGameHandler: (() -> Void)?
    fileprivate let scoreReferenceView = PointsReferenceView(frame: .zero)
    var didSelectedNumberOfPlayers = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.feltGreen
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !didSelectedNumberOfPlayers {
            let viewController = PlayerSelectionViewController()
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
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
        newGameButton.setTitle("New Game", for: .normal)
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
        let players = stateManager.game.players
        view.addSubview(scoreReferenceView)

        if players.count == 2 {
            scoreReferenceView.translatesAutoresizingMaskIntoConstraints = false
            scoreReferenceView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            scoreReferenceView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            scoreReferenceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            scoreReferenceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            for (idx, player) in players.enumerated() {
                let gameView = Player.newGameView()
                gameView.player = player
                
                view.addSubview(gameView)
                gameView.translatesAutoresizingMaskIntoConstraints = false
                gameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
                gameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
                if idx == 0 {
                    gameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
                    gameView.trailingAnchor.constraint(equalTo: scoreReferenceView.leadingAnchor).isActive = true
                } else {
                    gameView.leadingAnchor.constraint(equalTo: scoreReferenceView.trailingAnchor).isActive = true
                    gameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
                }
            }
        } else {
            scoreReferenceView.translatesAutoresizingMaskIntoConstraints = false
            scoreReferenceView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            scoreReferenceView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            scoreReferenceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            scoreReferenceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

            let scrollView = UIScrollView()
            scrollView.showsHorizontalScrollIndicator = false
            view.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.leadingAnchor.constraint(equalTo: scoreReferenceView.trailingAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

            let contentView = UIView()
            scrollView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

            var gameViews: [UIView] = []
            var gameViewWidth = 134.0
            let screenWidth = UIScreen.main.bounds.size.width
            if players.count > 2 && screenWidth > 500.0 {
                let gameViewPadding = 16.0
                gameViewWidth = (screenWidth - 80.0 - (gameViewPadding * Double(players.count))) / (Double(players.count))
            }
            for (idx, player) in players.enumerated() {
                let gameView = Player.newGameView()
                gameView.player = player
                
                contentView.addSubview(gameView)
                gameView.translatesAutoresizingMaskIntoConstraints = false
                gameView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                gameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                gameView.widthAnchor.constraint(equalToConstant: gameViewWidth).isActive = true
                
                if idx == 0 {
                    gameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                } else {
                    gameView.leadingAnchor.constraint(equalTo: gameViews[idx - 1].trailingAnchor, constant: 16.0).isActive = true
                }
                
                if idx == players.count - 1 {
                    gameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
                }
                
                gameViews.append(gameView)
            }
        }
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

extension GameViewController: PlayerSelectionViewControllerDelegate {
    func didSelectNumberOfPlayers(_ numberOfPlayers: Int) {
        didSelectedNumberOfPlayers = true
        
        // setup game
        let players = (0..<numberOfPlayers).map { _ in Player() }
        let game = Game(players: players)
        
        let stateManager = GameStateManager(game: game)
        stateManager.onGameEndedListener = displayWinner
        self.stateManager = stateManager
        stateManager.delegate = self
        
        buildPlayerViews()
        
        dismiss(animated: true, completion: nil)
    }
}
