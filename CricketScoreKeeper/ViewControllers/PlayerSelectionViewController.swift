//
//  PlayerSelectionViewController.swift
//  CricketScoreKeeper
//
//  Created by Mike Kavouras on 10/20/21.
//  Copyright © 2021 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

protocol PlayerSelectionViewControllerDelegate: AnyObject {
    func didSelectNumberOfPlayers(_ numberOfPlayers: Int)
}

class PlayerSelectionViewController: UIViewController {
    weak var delegate: PlayerSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .feltGreen
        setupUI()
    }
    
    private func setupUI() {
        let buttonViews: [UIButton] = (0..<3).map { idx in
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 32.0)
            button.setTitleColor(.white, for: .normal)
            button.setTitle("\(idx + 2)", for: .normal)
            button.tag = idx + 2
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            return button
        }
        
        let stackView = UIStackView(arrangedSubviews: buttonViews)
        stackView.spacing = 12.0
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        buttonViews.forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        let promptLabel = UILabel()
        promptLabel.textColor = UIColor.white
        promptLabel.font = UIFont(name: "Chalkboard SE", size: 28.0)
        promptLabel.textAlignment = .center
        promptLabel.text = "How many players?"
        view.addSubview(promptLabel)
        
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -80).isActive = true
        promptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func buttonTapped(button: UIButton) {
        delegate?.didSelectNumberOfPlayers(button.tag)
    }
}
