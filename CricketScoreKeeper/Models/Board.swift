//
//  Board.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 7/1/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation


struct Board {
    static let pieNumbers = [20, 19, 18, 17, 16, 15, 25]
    static let defaultPies = pieNumbers.map { Pie(value: $0) }
    
    let pies: [Pie]
    var isFull: Bool {
        return pies.first(where: { $0.state != .three }) == nil
    }

    init(pies: [Pie]? = nil) {
        self.pies = pies ?? Board.defaultPies
    }
    
    func hit(_ value: Int) -> Board {
        let np = pies.map { pie -> Pie in
            if pie.value == value {
                return pie.advance()
            } else {
                return Pie(value: pie.value, points: pie.points, state: pie.state)
            }
        }
        
        return Board(pies: np)
    }
    
    func unhit(_ value: Int) -> Board {
        let np = pies.map { pie -> Pie in
            if pie.value == value {
                return pie.revert()
            } else {
                return Pie(value: pie.value, points: pie.points, state: pie.state)
            }
        }
        
        return Board(pies: np)
    }
    
    func isClosed(_ value: Int) -> Bool {
        guard let pie = (pies.filter { $0.value == value }).first else { return false }
        return pie.state == .three
    }
    
    func score() -> Int {
        return pies.reduce(0) { $0 + $1.points }
    }
    
    
    func stateForPie(_ value: Int) -> PieState? {
        guard let pie = (pies.filter { $0.value == value }).first else { return nil }
        return pie.state
    }
}
