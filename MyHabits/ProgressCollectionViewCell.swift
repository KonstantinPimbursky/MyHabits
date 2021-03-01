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
    
    ///Передаем прогресс
    var todayProgress: Float? {
        didSet {
            habitsProgressView.progress = todayProgress!
            percentProgressLabel.text = "\(Int(todayProgress! * 100))%"
        }
    }
    
    ///Название ячейки
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получится!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    ///Полоса прогресса
    private let habitsProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressViewStyle = .default
        progressView.trackTintColor = .systemGray2
        progressView.progressTintColor = UIColor(named: "My Purple Color")
        return progressView
    }()
    
    ///Прогресс в процентах
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
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    private func setupViews() {
        contentView.addSubviews(nameLabel, habitsProgressView, percentProgressLabel)
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        let constraints = [
            contentView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            habitsProgressView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            habitsProgressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            habitsProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            habitsProgressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            habitsProgressView.heightAnchor.constraint(equalToConstant: 7),
            
            percentProgressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            percentProgressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
