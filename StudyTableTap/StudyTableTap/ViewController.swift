//
//  ViewController.swift
//  StudyTableTap
//
//  Created by MacBook Pro on 9/12/24.
//

import UIKit

class ViewController: UIViewController {

    let vcList: [(String, BaseTableVC.Type)] = [
        ("vc1-didSelect+tap", TableVC1.self),
        ("vc2-didSelect+tap+doubleTap", TableVC2.self),
        ("vc22-didSelect+tap+doubleTap-require_toFail", TableVC22.self),
        ("vc3-didSelect+tap+doubleTap-require_toFail+touchEnd-tapcall", TableVC3.self),
        ("vc4-didSelect+tap+doubleTap-require_toFail+touchEnd-touchData", TableVC4.self),
        ("vc5-didSelect+tap+doubleTap-require_toFail+???", TableVC5.self),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        var preBtn: UIButton? = nil
        for (title, _) in vcList {
            preBtn = createBtn(title: title, preBtn: preBtn)
        }
    }
    
    func createBtn(title: String, preBtn: UIButton?) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.numberOfLines = 0
        if let preBtn = preBtn {
            btn.tag = preBtn.tag + 1
            btn.frame = CGRectMake(20, preBtn.frame.maxY + 10, 350, 80)
        } else {
            btn.tag = 0
            btn.frame = CGRectMake(20, 100, 350, 80)
        }
        btn.backgroundColor = .systemCyan
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }

    @objc func btnClick(sender: UIButton) {
        let config = vcList[sender.tag]
        let vcClz = config.1
        let vc = vcClz.init()
        vc.titleStr = config.0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

