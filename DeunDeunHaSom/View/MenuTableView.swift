//
//  MenuTableView.swift
//  DeunDeunHaSom
//
//  Created by kim-wonhui on 2023/06/09.
//

import UIKit

final class MenuTableView: UIView {
    
    private var staffMeal = [String]()
    private var studentMeal = [String]()

    private lazy var mealTable: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(TableSectionHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "PointColor")
        
        configureUI()
        setupLayout()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

//tableView 관련 함수
extension MenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //섹션 당 행 개수
        
        switch section {
        case 0:
            return staffMeal.count
        case 1:
            return studentMeal.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = staffMeal[indexPath.row]
        case 1:
            cell.textLabel?.text = studentMeal[indexPath.row]
        default:
            return UITableViewCell()
        }
        
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func reloadTable(staffMenu: [String], studentMenu: [String]) {
        staffMeal = staffMenu
        studentMeal = studentMenu
        DispatchQueue.main.async { [weak self] in
            self?.mealTable.reloadData()
        }
    }
    
    //교직원 - 학식 섹션 2개
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension MenuTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TableSectionHeader else {
            return UIView()
        }
        
        header.configureSectionHeader(with: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //각 행 높이 조절
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            let lastIndex = staffMeal.count - 1
            if indexPath.row == 0 || indexPath.row == lastIndex {
                return 40
            }
        case 1:
            let lastIndex = studentMeal.count - 1
            if indexPath.row == 0 || indexPath.row == lastIndex {
                return 40
            }
        default:
            return 30
        }
        return 30
    }
}

//layout 관련 함수
extension MenuTableView {
    private func configureUI() {
        mealTable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mealTable)
        mealTable.backgroundColor = UIColor(named: "PointColor")
        mealTable.separatorStyle = .none //행 구분선 제거
        mealTable.allowsSelection = false //행 선택 불가
    }
    
    private func setupLayout() {
        let mealTableConstraints = [
            mealTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mealTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mealTable.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mealTable.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(mealTableConstraints)
    }
    
    private func setupTableView() {
        mealTable.dataSource = self
        mealTable.delegate = self
    }
}
