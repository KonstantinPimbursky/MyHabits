//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Konstantin Pimbursky on 23.02.2021.
//  Copyright © 2021 Konstantin Pimbursky. All rights reserved.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получится!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let habitsProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressViewStyle = .default
        progressView.trackTintColor = .systemGray2
        progressView.progressTintColor = UIColor(named: "My Purple Color")
        progressView.progress = HabitsStore.shared.todayProgress
        return progressView
    }()
    
    private let percentProgressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        percentProgressLabel.text = "\(Int(habitsProgressView.progress * 100))%"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
}
