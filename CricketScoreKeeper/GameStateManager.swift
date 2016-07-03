//
//  GameStateManager.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 7/1/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation

class GameStateManager {
    let game: Game
    
    lazy var gameController: GameViewController = {
        return GameViewController(game: self.game)
    }()
    
    var onGameEndedListener: ((Player) -> Void)?
    
    init(game: Game) {
        self.game = game
        game.players.forEach { addPlayer($0) }
    }
    
    func addPlayer(player: Player) {
        player.shouldCommitMove = shouldCommitMoveHandler
        player.validateWin = checkWinValidator
    }
    
    func checkWinValidator(player: Player) {
        guard let otherPlayer = (game.players.filter { $0 != player }.first) else {
            return
        }
        
        if player.board.isFull && player.score >= otherPlayer.score {
            onGameEndedListener?(player)
        }
    }
    
    func shouldCommitMoveHandler(player: Player, move: Move) -> Bool {
        if move.direction == .add {
            guard let otherPlayer = (game.players.filter { $0 != player }.first) else {
                return false
            }
            
            if !player.hasClosed(move.value) {
                return true
            }
            
            if !otherPlayer.hasClosed(move.value) {
                return true
            }
            
            if player.hasClosed(move.value) && !otherPlayer.hasClosed(move.value) {
                return true
            }
            
            return false
        } else {
            if player.board.stateForPie(move.value) != .zero {
                return true
            }
            return false
        }
    }
}
