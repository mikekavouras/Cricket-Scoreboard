//
//  AppDelegate.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 6/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        startNewGame()
        
        return true
    }
    
    func startNewGame() {
        window?.rootViewController = newGameViewController()
    }
    
    fileprivate func newGameViewController() -> UIViewController {
        let player1 = Player()
        let player2 = Player()
        let game = Game(players: player1, player2)
        let stateManager = GameStateManager(game: game)
        let viewController = stateManager.gameController
        viewController.shouldBeginNewGameHandler = startNewGame
        stateManager.onGameEndedListener = viewController.displayWinner
        return viewController
    }

}

