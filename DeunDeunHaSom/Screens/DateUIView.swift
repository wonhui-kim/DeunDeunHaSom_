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
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
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
        
        let dateLabelConstraints = [
            dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 155),
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50)
        ]
        
        let dayLabelConstraints = [
            dayLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 167),
            dayLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 90)
        ]
        
        let leftButtonConstraints = [
            leftButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 90),
            leftButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70)
        ]
        
        let rightButtonConstraints = [
            rightButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 290),
            rightButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70)
        ]
        
        [dateLabelConstraints, dayLabelConstraints, leftButtonConstraints, rightButtonConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
    }
}
