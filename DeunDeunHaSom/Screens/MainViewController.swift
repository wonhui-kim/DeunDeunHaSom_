//
//  MainViewController.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureDateView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = UIColor(named: "PointColor")
        
    }
    
    private func configureNavBar() {
        let leftBarButtonItem = UIBarButtonItem(title: fetchYearAndMonth(), style: .plain, target: .none, action: .none)
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func configureDateView() {
        let dateView = DateUIView()
        view.addSubview(dateView)
        
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160)
        ]
        
        NSLayoutConstraint.activate(dateViewConstraints)
    }
}
