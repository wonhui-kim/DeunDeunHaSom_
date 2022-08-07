//
//  ViewController.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/07.
//

import UIKit

class ViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mainView = MainViewController()
        self.pushViewController(mainView, animated: true)
    }


}

