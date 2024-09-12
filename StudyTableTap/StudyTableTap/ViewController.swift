//
//  ViewController.swift
//  StudyTableTap
//
//  Created by MacBook Pro on 9/12/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn1 = createBtn(title: "vc1", tag: 0)
        btn1.frame = CGRectMake(20, 100, 150, 40)
        let btn2 = createBtn(title: "vc2", tag: 1)
        btn2.frame = CGRectMake(20, 150, 150, 40)
    }
    
    func createBtn(title: String, tag: Int) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.tag = tag
        btn.backgroundColor = .systemCyan
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }

    @objc func btnClick(sender: UIButton) {
        if sender.tag == 0 {
            self.navigationController?.pushViewController(TableVC1(), animated: true)
        } else {
            self.navigationController?.pushViewController(TableVC2(), animated: true)
        }
    }
}

