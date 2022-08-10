//
//  MainViewController.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//
import UIKit

class MainViewController: UIViewController {
    
    let meal: [String] = ["잡곡밥", "&덮밥용 마파두부", "파송송 계란국", "탕수육*새콤달콤소스", "노각양파무침", "반달단무지", "배추김치"]
    
    private lazy var mealTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let dateView = DateUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealTable.dataSource = self
        
        configureDateView()
        configureMealTable()
        configureMealTableHeader()
        
        CrawlManager.crawlStaffMeal()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = UIColor(named: "PointColor")
        
        mealTable.layer.cornerRadius = 22
        mealTable.separatorStyle = .none
        mealTable.rowHeight = 30
        mealTable.isScrollEnabled = false
        mealTable.allowsSelection = false
    }
    
    private func configureDateView() {
        view.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            dateView.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        NSLayoutConstraint.activate(dateViewConstraints)
    }
    
    private func configureMealTable() {
        view.addSubview(mealTable)
        mealTable.translatesAutoresizingMaskIntoConstraints = false
        
        let mealTableConstraints = [
            mealTable.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 30),
            mealTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -340),
            mealTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            mealTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ]
        
        NSLayoutConstraint.activate(mealTableConstraints)
    }
    
    private func configureMealTableHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "교직원 식당"
            label.font = .systemFont(ofSize: 25, weight: .bold)
            label.textAlignment = .left
            return label
        }()
        
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text = "(11:30 - 13:00)"
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.textAlignment = .right
            return label
        }()
        
        [titleLabel, timeLabel].forEach { component in
            header.addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 20)
        ]
        
        let timeLabelConstraints = [
            timeLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20),
            timeLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 25)
        ]
        
        [titleLabelConstraints, timeLabelConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
        
        mealTable.tableHeaderView = header
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = meal[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
}
