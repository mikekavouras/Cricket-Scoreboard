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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        window?.makeKeyAndVisible()
        
        startNewGame()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        return true
    }
    
    func startNewGame() {
        window?.rootViewController = newGameViewController()
    }
    
    fileprivate func newGameViewController() -> UIViewController {
        let viewController = GameViewController()
        viewController.shouldBeginNewGameHandler = { [weak self] in
            self?.startNewGame()
        }
        
        return viewController
    }

}

