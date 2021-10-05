//
//  PointsReferenceView.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 7/2/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import SnapKit

class PointsReferenceView: UIView {
    private let containerView = UIView()
    
    private let points = [20, 19, 18, 17, 16, 15, 25]
    private var pointsDisplayable: [String] {
        return points.map { "\($0)" }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        render([:])
    }
    
    func render(_ state: [Int: (player1: Bool, player2: Bool)]) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        // Spacer view
        
        let spacerView = UIView()
        containerView.addSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(60.0)
        }
        
        // Score view
        
        let scoreView = UIView()
        containerView.addSubview(scoreView)
        scoreView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(60.0)
        }
        let scoreLabel = UILabel()
        scoreLabel.text = "Score"
        scoreLabel.font = UIFont(name: "Chalkboard SE", size: 21.0)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        
        // Score labels
    
        let scoreLabels: [UILabel] = points.compactMap { point -> UILabel? in
            guard let displayable = [20: "20", 19: "19", 18: "18", 17: "17", 16: "16", 15: "15", 25: "B"][point] else { return nil }

            let label = UILabel(frame: .zero)
            label.textColor = .white
            label.text = displayable
            
            if let player1Closed = state[point]?.player1,
               let player2Closed = state[point]?.player2 {
                label.alpha = player1Closed && player2Closed ? 0.4 : 1.0
            }

            label.font = UIFont(name: "Chalkboard SE", size: 26)
            label.textAlignment = .center
            return label
        }
        
        // stack view
        
        let stackView = UIStackView(arrangedSubviews: scoreLabels)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 8.0
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(spacerView.snp.bottom)
            make.bottom.equalTo(scoreView.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
