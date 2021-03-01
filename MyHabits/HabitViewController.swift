//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Konstantin Pimbursky on 15.02.2021.
//  Copyright © 2021 Konstantin Pimbursky. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    public var habit: Habit? {
        didSet {
            habitTextField.text = habit?.name
            timeTextField.text = formatter.string(from: habit!.date)
            colorCircleView.backgroundColor = habit?.color
        }
    }
    
    ///Навигейшн бар для названия и кнопок сохранения и отмены
    private let navBar: UINavigationBar = {
        let bar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        bar.backgroundColor = UIColor(named: "My Light Grey Color")
        return bar
    }()
    
    ///Элементы навигейшн бара
    private let navItem = UINavigationItem()
    
    ///Вью, на которой разместим все объекты
    private let habbitContentView: UIView = {
        let someView = UIView()
        someView.translatesAutoresizingMaskIntoConstraints = false
        return someView
    }()
    
    ///Лейбл "Название"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = "НАЗВАНИЕ"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Поле для ввода привычки
    private let habitTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .none
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        return textField
    }()
    
    ///Лейбл ЦВЕТ
    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = "ЦВЕТ"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Цветовой круг
    private let colorCircleView: UIView = {
        let someView = UIView()
        someView.translatesAutoresizingMaskIntoConstraints = false
        someView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        someView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        someView.layer.cornerRadius = 15
        someView.clipsToBounds = true
        return someView
    }()
    
    ///Лейбл ВРЕМЯ
    private let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = "ВРЕМЯ"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Фиксированный текст для времени
    private let timeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Каждый день в "
        label.textColor = .black
        return label
    }()
    
    ///Поле, в котором выбирается время
    private let timeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.backgroundColor = .none
        textField.textColor = UIColor(named: "My Purple Color")
        textField.autocapitalizationType = .none
        return textField
    }()
    
    ///Колеса выбора времени
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .white
        return picker
    }()
    
    ///Форматер даты/времени
    private let formatter = DateFormatter()
    
    private let deleteHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    var reloadCollectionViewDelegate: ReloadCollectionView?
    
    var closeViewControllerDelegate: CloseViewController?
    
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        navItem.title = "Создать"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelAction))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAction))
        navItem.leftBarButtonItem?.tintColor = UIColor(named: "My Purple Color")
        navItem.rightBarButtonItem?.tintColor = UIColor(named: "My Purple Color")
        
        
        navBar.items = [navItem]
        
        view.backgroundColor = .white
        view.addSubview(navBar)
        
        if habit == nil {
            colorCircleView.backgroundColor = UIColor(named: "My Orange Color")
        }
        
        setupViews()
        
        timeTextField.inputView = datePicker
        formatter.dateFormat = "HH:mm"
        if habit == nil {
            timeTextField.text = formatter.string(from: datePicker.date)
        } else {
            timeTextField.text = formatter.string(from: habit!.date)
        }
        datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneAction)))
        
        colorCircleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeColor)))
        
        deleteHabitButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    }
    
    @objc private func doneAction () {
        view.endEditing(true)
    }
    
    @objc private func timeChanged() {
        timeTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func changeColor() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Выберите цвет"
        colorPicker.selectedColor = .orange
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveAction() {
        guard let name = habitTextField.text else { return }
        guard let date = formatter.date(from: timeTextField.text!) else { return }
        guard let color = colorCircleView.backgroundColor else { return }
        let newHabit = Habit(name: name,
                             date: date,
                             color: color)
        let store = HabitsStore.shared
        if habit != nil {
            habit?.name = name
            habit?.date = date
            habit?.color = color
            store.save()
        } else {
            store.habits.append(newHabit)
            self.dismiss(animated: true, completion: nil)
        }
        self.reloadCollectionViewDelegate?.reloadCollectionView()
        self.closeViewControllerDelegate?.closeViewController()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showAlert() {
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit!.name)?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            print("Отмена")
        }
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) {_ in
            let store = HabitsStore.shared
            let newHabitsArray = store.habits.filter{ $0 != self.habit }
            store.habits = newHabitsArray
            store.save()
            self.closeViewControllerDelegate?.closeViewController()
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupViews() {
              
        view.addSubviews(titleLabel, habitTextField, colorTitleLabel, colorCircleView, timeTitleLabel, timeTextLabel, timeTextField)
        
        var constraints = [
                       
            titleLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            habitTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            habitTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habitTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            colorTitleLabel.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 15),
            colorTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            colorCircleView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 7),
            colorCircleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            timeTitleLabel.topAnchor.constraint(equalTo: colorCircleView.bottomAnchor, constant: 15),
            timeTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            timeTextLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 7),
            timeTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            timeTextField.topAnchor.constraint(equalTo: timeTextLabel.topAnchor),
            timeTextField.leadingAnchor.constraint(equalTo: timeTextLabel.trailingAnchor)
        ]
        
        if habit != nil {
            view.addSubview(deleteHabitButton)
            constraints += [
                deleteHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                deleteHabitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ]
        }
 
        NSLayoutConstraint.activate(constraints)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorCircleView.backgroundColor = viewController.selectedColor
    }
    
    
}
