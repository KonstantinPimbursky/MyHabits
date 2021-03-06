//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Konstantin Pimbursky on 15.02.2021.
//  Copyright © 2021 Konstantin Pimbursky. All rights reserved.
//

import UIKit

///Протокол для делегата, чтобы в необходимый момент обновить колеекцию
protocol  ReloadCollectionView {
    func reloadCollectionView() -> Void
}

class HabitsViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    
    ///Коллекция, содержащая привычки и ProgressBar
    public lazy var habitsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "My Light Grey Color")
        return collectionView
    }()
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Сегодня"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.backgroundColor = .white
        
        setupCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        habitsCollectionView.reloadData()
    }
    
    private func setupCollection() {
        view.addSubview(habitsCollectionView)
        
        habitsCollectionView.delegate = self
        habitsCollectionView.dataSource = self
        habitsCollectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")
        habitsCollectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: "ProgressCell")
        habitsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Progress")
        habitsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Habit")
        
        let constraints = [
            habitsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @IBAction func createNewHabit(_ sender: Any) {
        let habitViewController = HabitViewController()
        habitViewController.reloadCollectionViewDelegate = self
        present(habitViewController, animated: true, completion: nil)
    }
}

// MARK: - EXTENSIONS
extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width - 32, height: 60)
        default:
            return CGSize(width: collectionView.frame.width - 32, height: 130)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return HabitsStore.shared.habits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: ProgressCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath) as! ProgressCollectionViewCell
            cell.todayProgress = HabitsStore.shared.todayProgress
            return cell
        default:
            let cell: HabitCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as! HabitCollectionViewCell
            cell.habit = HabitsStore.shared.habits[indexPath.item]
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets.init(top: 22, left: 16, bottom: 6, right: 16)
        default:
            return UIEdgeInsets.init(top: 6, left: 16, bottom: 22, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        let habit = HabitsStore.shared.habits[indexPath.item]
        let habitDetailsViewController = HabitDetailsViewController.init(habit: habit)
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
    }
}
extension HabitsViewController: ReloadCollectionView {
    func reloadCollectionView() {
        habitsCollectionView.reloadData()
    }
}
