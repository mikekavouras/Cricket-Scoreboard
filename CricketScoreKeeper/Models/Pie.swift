//
//  Pie.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 7/1/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

func >(lhs: PieState, rhs: PieState) -> Bool {
    if lhs == rhs { return false }
    
    switch lhs {
    case .zero: return false
    case .one: return rhs == .zero
    case .two: return rhs != .three
    case .three: return true
    }
}

func <(lhs: PieState, rhs: PieState) -> Bool {
    if lhs == rhs { return false }
    return  !(lhs > rhs)
}

enum PieState {
    case zero
    case one
    case two
    case three
    
    func advance() -> PieState? {
        switch self {
        case .zero:
            return .one
        case .one:
            return .two
        case .two:
            return .three
        case .three:
            return nil
        }
    }
    
    func revert() -> PieState {
        switch self {
        case .zero:
            return .zero
        case .one:
            return .zero
        case .two:
            return .one
        case .three:
            return .two
        }
    }
    
    func visualBase() -> String? {
        switch self {
        case .zero:
            return nil
        case .one:
            return "slash"
        case .two:
            return "ex"
        case .three:
            return "circle"
        }
    }
}

struct Pie {
    var state: PieState = .zero
    var points: Int = 0
    let value: Int
    
    var isClosed: Bool {
        return state == .three
    }
    
    init(value: Int) {
        self.value = value
    }
    
    init(value: Int, points: Int, state: PieState) {
        self.value = value
        self.points = points
        self.state = state
    }
    
    func advance() -> Pie {
        if let state = state.advance() {
            return Pie(value: value, points: points, state: state)
        } else {
            let newPoints = points + value
            return Pie(value: value, points: newPoints, state: state)
        }
    }
    
    func revert() -> Pie {
        if points > 0 {
            let newPoints = points - value
            return Pie(value: value, points: newPoints, state: state)
        } else {
            return Pie(value: value, points: points, state: state.revert())
        }
    }
}
 
