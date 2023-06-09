//
//  MainViewController.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let dateUIView = DateUIView()
    private let menuTableView = MenuTableView()
    
    private let dateManager = DateManager.shared
    private let menuStorage = MenuStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupLayout()
        
        view.backgroundColor = .systemBackground
        dateUIView.delegate = self
        
        let startEndDate = dateManager.startEndDate()
        fetchData(parameters: startEndDate)
    }
}

extension MainViewController {
    //파라미터 date를 넣으면 일주일간의 데이터를 호출하고, 각 식단을 저장한 후, tableView 리로드
    func fetchData(parameters: [String:String]) {
        Task {
            do {
                let result = try await requestMenus(parameters: parameters)
                handleMenus(result)
            } catch let error as NSError {
                print(error)
                //네트워크 에러 -> 앱 재실행 요청 문구 띄우기
            }
        }
    }
    
    func requestMenus(parameters: [String:String]) async throws -> [String] {
        let url = "https://www.dongduk.ac.kr/ajax/etc/cafeteria/cafeteria_data.json?"
        
        let result = try await NetworkManager.shared.requestData(url: url, parameters: parameters)
        
        //일주일 치 저장
        menuStorage.saveWeekMenus(menus: result)
        
        return result
    }
    
    func handleMenus(_ result: [String]) {
        let todayIndex = dateManager.todayIndex()
        let staffMenu = menuStorage.dayStaffMenu(dayIndex: todayIndex)
        let studentMenu = menuStorage.dayStudentMenu(dayIndex: todayIndex)
        
        menuTableView.reloadTable(staffMenu: staffMenu, studentMenu: studentMenu)
    }
}

//view layout 관련 함수
extension MainViewController {
    private func configureUI() {
        [dateUIView, menuTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupLayout() {
        let dateUIViewConstraints = [
            dateUIView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateUIView.heightAnchor.constraint(equalToConstant: 116)
        ]
        
        let menuTableViewConstraints = [
            menuTableView.topAnchor.constraint(equalTo: dateUIView.bottomAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        [dateUIViewConstraints, menuTableViewConstraints].forEach {
            NSLayoutConstraint.activate($0)
        }
    }
}

extension MainViewController: DateUIViewDelegate {
    func renewWeekData(parameter: [String : String]) {
        fetchData(parameters: parameter)
    }
    
    func updateMenu(index: Int) {
        let staffMenu = menuStorage.dayStaffMenu(dayIndex: index)
        let studentMenu = menuStorage.dayStudentMenu(dayIndex: index)
        
        menuTableView.reloadTable(staffMenu: staffMenu, studentMenu: studentMenu)
    }
}
