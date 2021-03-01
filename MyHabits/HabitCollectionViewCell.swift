//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Konstantin Pimbursky on 23.02.2021.
//  Copyright © 2021 Konstantin Pimbursky. All rights reserved.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    ///Принимает привычку с данными для ячейки
    var habit: Habit? {
        didSet {
            nameLabel.text = habit?.name
            nameLabel.textColor = habit?.color
            timeLabel.text = habit?.dateString
            if habit!.trackDates.isEmpty {
                inARowLabel.text = "Подряд: 0"
            } else {
                inARowLabel.text = "Подряд: \(habit!.trackDates.count)"
            }
            if habit!.isAlreadyTakenToday {
                colorCircle.backgroundColor = habit?.color
            } else {
                colorCircle.backgroundColor = .white
            }
            colorCircle.layer.borderColor = habit?.color.cgColor
        }
    }
    
    //Имя привычки
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    ///Время выполнения привычки
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray2
        return label
    }()
    
    ///Сколько раз подряд выполнена привычка
    private let inARowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    ///Цветовой круг
    private let colorCircle: UIView = {
        let someView = UIView()
        someView.translatesAutoresizingMaskIntoConstraints = false
        someView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        someView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        someView.layer.cornerRadius = 18
        someView.layer.borderWidth = 2
        return someView
    }()
    
    ///Галочка выполненной привычки
    private let checkMarkImageView: UIImageView = {
           let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        return imageView
    }()
    
    ///Делегат для обновления коллекции
    var delegate: ReloadCollectionView?
    
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(trackHabit))
        colorCircle.addGestureRecognizer(recognizer)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    private func setupViews() {
        contentView.addSubviews(nameLabel, timeLabel, inARowLabel, colorCircle, checkMarkImageView)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = true
        
        let constraints = [
            contentView.heightAnchor.constraint(equalToConstant: 130),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            inARowLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            inARowLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            colorCircle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 47),
            colorCircle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47),
            colorCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            
            checkMarkImageView.centerXAnchor.constraint(equalTo: colorCircle.centerXAnchor),
            checkMarkImageView.centerYAnchor.constraint(equalTo: colorCircle.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func trackHabit() {
        if habit!.isAlreadyTakenToday {
            return
        } else {
            HabitsStore.shared.track(habit!)
            colorCircle.backgroundColor = habit?.color
            self.delegate?.reloadCollectionView()
        }
    }
    

}
