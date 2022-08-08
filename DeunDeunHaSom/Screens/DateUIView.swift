//
//  DateUIView.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//

import UIKit

class DateUIView: UIView {
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = fetchDate()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = fetchDay()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DateUIView {
    private func configureSubviews() {
        [dateLabel, dayLabel, leftButton, rightButton].forEach { component in
            addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let dateLabelConstriants = [
            dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 180),
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100)
        ]
        
        let dayLabelConstraints = [
            dayLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 167),
            dayLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 140)
        ]
        
        let leftButtonConstraints = [
            leftButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 110),
            leftButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 120)
        ]
        
        let rightButtonConstraints = [
            rightButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 270),
            rightButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 120)
        ]
        
        [dateLabelConstriants, dayLabelConstraints, leftButtonConstraints, rightButtonConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
        
    }
}
