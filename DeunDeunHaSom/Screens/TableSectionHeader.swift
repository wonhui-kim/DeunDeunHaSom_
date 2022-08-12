//
//  TableSectionHeader.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/12.
//

import UIKit

class TableSectionHeader: UITableViewHeaderFooterView {
    static let identifier = "TableSectionHeader"
    
    private lazy var restaurantName: UILabel = {
        let label = UILabel()
        label.text = "교직원 식당"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var operatingHours: UILabel = {
        let label = UILabel()
        label.text = "(11:30 - 13:00)"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TableSectionHeader {
    private func configureSubviews() {
        [restaurantName, operatingHours].forEach { component in
            contentView.addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let restaurantNameConstraints = [
            restaurantName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            restaurantName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        let operatingHoursConstraints = [
            operatingHours.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            operatingHours.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        [restaurantNameConstraints, operatingHoursConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
    }
}
