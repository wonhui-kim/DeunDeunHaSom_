//
//  DateUIView.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//
import UIKit

class DateUIView: UIView {
    
    var dateManager = DateManager()
    private var parent: MainViewController?
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = dateManager.fetchDate()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = dateManager.fetchDayKor()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        if dayLabel.text! == dateManager.fetchTodayKor() {
            button.isEnabled = false
        }
        
        button.addTarget(self, action: #selector(subtractDateAndDay), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(addDateAndDay), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    func addDateAndDay() {
        dateManager.addDate()
        dateLabel.text = dateManager.fetchDate()
        dayLabel.text = dateManager.fetchDayKor()
        
        parent?.updateMeal(restaurant: "staffMeal", day: dateManager.fetchDayEn().lowercased())
        parent?.updateMeal(restaurant: "studentMeal", day: dateManager.fetchDayEn().lowercased())
        
        if dayLabel.text! != dateManager.fetchTodayKor() {
            leftButton.isEnabled = true
        }
        
        if dayLabel.text == dateManager.dayAfterTomorrowKor() {
            rightButton.isEnabled = false
        }
    }
    
    @objc
    func subtractDateAndDay() {
        dateManager.subtractDate()
        dateLabel.text = dateManager.fetchDate()
        dayLabel.text = dateManager.fetchDayKor()
        parent?.updateMeal(restaurant: "staffMeal", day: dateManager.fetchDayEn().lowercased())
        parent?.updateMeal(restaurant: "studentMeal", day: dateManager.fetchDayEn().lowercased())
        
        if dayLabel.text! == dateManager.fetchTodayKor() {
            leftButton.isEnabled = false
        }
        
        if dayLabel.text != dateManager.dayAfterTomorrowKor() {
            rightButton.isEnabled = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DateUIView {
    
    func setParentViewController(view: MainViewController) {
        parent = view
    }
    
    private func configureSubviews() {
        [dateLabel, dayLabel, leftButton, rightButton].forEach { component in
            addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let dateLabelConstraints = [
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ]
        
        let dayLabelConstraints = [
            dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 40)
        ]
        
        let leftButtonConstraints = [
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80),
            leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        let rightButtonConstraints = [
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80),
            rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        [dateLabelConstraints, dayLabelConstraints, leftButtonConstraints, rightButtonConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
    }
}
