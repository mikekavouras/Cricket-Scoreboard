//
//  Player.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 7/1/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation

enum MoveDirection {
    case add
    case subtract
}

typealias Move = (direction: MoveDirection, value: Int)

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.uid == rhs.uid
}

class Player: Equatable {
    static var nextUid = 0
    static func generateUid() -> Int {
        nextUid += 1
        return nextUid
    }
    
    let uid: Int
    var board = Board()
    var score: Int { return board.score() }
    var shouldCommitMove: ((Player, Move) -> Bool)!
    var validateWin: ((Player) -> Void)!
    
    class var gameView: PlayerGameView {
        let view = PlayerGameView.initFromNib()
        return view
    }
    
    init() {
        uid = Player.generateUid()
    }
    
    func hit(_ value: Int) {
        let move: Move = (direction: .add, value: value)
        if shouldCommitMove(self, move) {
            board = board.hit(value)
        }
        
        validateWin(self)
    }
    
    func unhit(_ value: Int) {
        let move: Move = (direction: .subtract, value: value)
        if shouldCommitMove(self, move) {
            board = board.unhit(value)
        }
    }
    
    func hasClosed(_ value: Int) -> Bool {
        return board.isClosed(value)
    }
    
    func printStatus() {
        print("20: \(board.stateForPie(20)!)")
        print("19: \(board.stateForPie(19)!)")
        print("18: \(board.stateForPie(18)!)")
        print("17: \(board.stateForPie(17)!)")
        print("16: \(board.stateForPie(16)!)")
        print("15: \(board.stateForPie(15)!)")
        print("B: \(board.stateForPie(25)!)")
        print("Score: \(score)")
    }
}

