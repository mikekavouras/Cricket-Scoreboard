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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()
        
        startNewGame()
        
        return true
    }
    
    func startNewGame() {
        window?.rootViewController = newGameViewController()
    }
    
    private func newGameViewController() -> UIViewController {
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

