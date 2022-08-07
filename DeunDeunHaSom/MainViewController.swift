//
//  MainViewController.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/07.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = UIColor(named: "PointColor")
    }
    
    private func configureNavBar() {
        let leftBarButtonItem = UIBarButtonItem(title: "2022년 08월", style: .plain, target: .none, action: .none)
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}
