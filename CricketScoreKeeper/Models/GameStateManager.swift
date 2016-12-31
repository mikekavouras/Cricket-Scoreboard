//
//  GameStateManager.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 7/1/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation

protocol GameStateManagerDelegate: class {
    func gameStateDidChange(manager: GameStateManager)
}

class GameStateManager {
    let game: Game
    
    var onGameEndedListener: ((Player) -> Void)?
    weak var delegate: GameStateManagerDelegate?
    
    init(game: Game) {
        self.game = game
        game.players.forEach { [weak self] player in
            player.delegate = self
            player.validateWin = { player in
                self?.checkWinValidator(player)
            }
        }
    }
    
    var competitivePieStates: [Int:(Bool, Bool)] {
        guard let player1 = game.players.first,
            let player2 = game.players.last else { return [:] }
        
        let pies = (player1.board.pies, player2.board.pies)
        var value: [Int: (Bool, Bool)] = [:]
        for (index, pie) in pies.0.enumerated() {
            let leftIsGreater = pie.state > pies.1[index].state
            let rightIsGreater = pie.state < pies.1[index].state
            value[pie.value] = (leftIsGreater, rightIsGreater)
        }
        
        return value
    }
    
    private func checkWinValidator(_ player: Player) {
        guard let otherPlayer = (game.players.filter { $0 != player }.first) else {
            return
        }
        
        if player.board.isFull && player.score >= otherPlayer.score {
            onGameEndedListener?(player)
        }
    }
    
    fileprivate func shouldCommitMoveHandler(_ player: Player, move: Move) -> Bool {
        if move.direction == .add {
            guard let otherPlayer = (game.players.filter { $0 != player }.first) else {
                return false
            }
            
            if !player.hasClosed(move.value) || !otherPlayer.hasClosed(move.value) {
                return true
            }
            
            return false
        } else {
            return player.board.stateForPie(move.value) != .zero
        }
    }
}

extension GameStateManager: PlayerDelegate {
    func playerShouldCommitMove(_ player: Player, move: Move) -> Bool {
        return shouldCommitMoveHandler(player, move: move)
    }
    
    func playerDidCommitMove(_ player: Player, move: Move) {
        delegate?.gameStateDidChange(manager: self)
    }
}
