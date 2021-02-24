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
        someView.backgroundColor = UIColor(named: "My Orange Color")
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
        
        setupViews()
        
        timeTextField.inputView = datePicker
        formatter.dateFormat = "hh:mm a"
        timeTextField.text = formatter.string(from: datePicker.date)
        datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneAction)))
        colorCircleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeColor)))
    }
    
    @objc func doneAction () {
        view.endEditing(true)
    }
    
    @objc func timeChanged() {
        timeTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func changeColor() {
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
        store.habits.append(newHabit)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
              
        view.addSubviews(titleLabel, habitTextField, colorTitleLabel, colorCircleView, timeTitleLabel, timeTextLabel, timeTextField)
        
        let constraints = [
                       
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
 
        NSLayoutConstraint.activate(constraints)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorCircleView.backgroundColor = viewController.selectedColor
    }
    
    
}
