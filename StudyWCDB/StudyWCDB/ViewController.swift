//
//  ViewController.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/15/24.
//

import UIKit
import WCDBSwift

// https://juejin.cn/post/6844904117446377485

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //PathTool.documentsDirectory.append(path: <#T##StringProtocol#>)
        // Do any additional setup after loading the view.
        let db = Database(at: "/xx/xx/xx.db")
        let stus: [StudentDBModel] = []
        do {
            try db.insert(stus, intoTable: "")
            let list: [StudentDBModel] = try db.getObjects(on: StudentDBModel.Properties.all, fromTable: "", where: StudentDBModel.Properties.identifier.in([""]))
            
            
            
        } catch {
            
        }
    }


}

