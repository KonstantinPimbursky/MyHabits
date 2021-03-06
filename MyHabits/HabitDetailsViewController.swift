//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Konstantin Pimbursky on 28.02.2021.
//  Copyright © 2021 Konstantin Pimbursky. All rights reserved.
//

import UIKit

protocol CloseViewController {
    func closeViewController() -> Void
}

class HabitDetailsViewController: UIViewController {
    //MARK: - PROPERTIES
    
    ///Привычка, чьи детали мы показываем
    public var habit: Habit
    
    ///Таблица, содержащая даты
    private let detailsTableView = UITableView.init(frame: .zero, style: .grouped)
    
    ///Заголовок в NavigationBar
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3).isActive = true
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    //MARK: - INIT
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailsTableView)
        view.backgroundColor = UIColor(named: "My Light Grey Color")
        
        titleLabel.text = habit.name
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor(named: "My Purple Color")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editAction))
        
        setupTableView()
    }
    
    private func setupTableView() {
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.register(TableViewCell.self, forCellReuseIdentifier: "DetailCell")
        detailsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            detailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func editAction() {
        let habitViewController = HabitViewController()
        habitViewController.habit = habit
        habitViewController.closeViewControllerDelegate = self
        present(habitViewController, animated: true, completion: nil)
    }
}

//MARK: - EXTENSIONS
extension HabitDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ///Не используем "Сегодня", поэтому на 1 меньше
        return HabitsStore.shared.dates.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        ///Формат отображения времени
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM y"
        
        ///Номер ячейки массива, чтобы даты показывались от новых к старым. "- 2 " - потому что не используем сегодняшнюю дату
        let habitNumber = HabitsStore.shared.dates.count - 2 - indexPath.item
        
        switch habitNumber {
        case HabitsStore.shared.dates.count - 2:
            cell.textLabel?.text = "Вчера"
        case HabitsStore.shared.dates.count - 3:
            cell.textLabel?.text = "Позавчера"
        default:
            cell.textLabel?.text = formatter.string(from: HabitsStore.shared.dates[habitNumber])
        }
        
        if HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[habitNumber]) {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(named: "My Purple Color")
        } else {
            cell.accessoryType = .none
        }
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension HabitDetailsViewController: CloseViewController {
    func closeViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}

class TableViewCell: UITableViewCell {
    
}
