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
    
    private func addPlayer(_ player: Player) {
        player.shouldCommitMove = shouldCommitMoveHandler
        player.validateWin = checkWinValidator
    }
    
    private func checkWinValidator(_ player: Player) {
        guard let otherPlayer = (game.players.filter { $0 != player }.first) else {
            return
        }
        
        if player.board.isFull && player.score >= otherPlayer.score {
            onGameEndedListener?(player)
        }
    }
    
    private func shouldCommitMoveHandler(_ player: Player, move: Move) -> Bool {
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
            
            return false
        } else {
            return player.board.stateForPie(move.value) != .zero
        }
    }
}
