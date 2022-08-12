//
//  MainViewController.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//

import UIKit

class MainViewController: UIViewController {
    
    private let dateManager = DateManager()
    private let networkManager = NetworkManager()
    
    let restaurants = ["교직원 식당", "학생 식당"]
    var staffMeal = [String]()
    var studentMeal = [String]()
    
    private lazy var mealTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(TableSectionHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        return table
    }()
    
    private let dateView = DateUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealTable.dataSource = self
        mealTable.delegate = self
        dateView.setParentViewController(view: self)
        
        DispatchQueue.main.async {
            self.updateMeal(restaurant: "staffMeal", day: self.dateManager.fetchDayEn().lowercased())
        }
        DispatchQueue.main.async {
            self.updateMeal(restaurant: "studentMeal", day: self.dateManager.fetchDayEn().lowercased())
        }
        
        configureDateView()
        configureMealTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = UIColor(named: "PointColor")
        
        mealTable.layer.cornerRadius = 22
        mealTable.separatorStyle = .none
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
        mealTable.backgroundColor = UIColor(named: "PointColor")
        
        let mealTableConstraints = [
            mealTable.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 30),
            mealTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mealTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mealTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(mealTableConstraints)
    }
}

extension MainViewController {
    func updateMeal(restaurant: String, day: String) {
        networkManager.getMultipleAll(restaurant: restaurant, day: day) { [weak self] results in
            switch results {
            case .success(var info):
                if info.isEmpty { //데이터가 없을 경우
                    info.append(contentsOf: ["", "", "", "오늘은 운영하지 않아요 🥲", "", "", ""])
                }
                if restaurant == "staffMeal" {
                    self?.staffMeal = info
                } else {
                    self?.studentMeal = info
                }
                self?.mealTable.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return staffMeal.count
        case 1:
            return studentMeal.count
        default:
            return 0
        }
    }
    
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
            return 0
        }
        return 30
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
}

extension MainViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return restaurants.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return restaurants[section]
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        header.textLabel?.textColor = .white
    }
}
