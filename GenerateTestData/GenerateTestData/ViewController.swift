//
//  ViewController.swift
//  GenerateTestData
//
//  Created by wrustem on 09.03.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .red
        
        let but = UIButton()
        but.backgroundColor = .blue
        but.frame = CGRect(x: 200, y: 200, width: 100, height: 50)
        but.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        view.addSubview(but)
    }


    @objc
    func tappedButton() {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
}

