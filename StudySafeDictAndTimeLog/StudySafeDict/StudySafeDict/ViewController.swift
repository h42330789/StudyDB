//
//  ViewController.swift
//  StudySafeDict
//
//  Created by MacBook Pro on 8/12/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tag = "ViewController"
        RecordDuration.log(tag: tag, msg: "start")
        let dict = PThreadSafeDictionary<Int, String>()
        RecordDuration.log(tag: tag, msg: "ready-A")
        for i in 0..<30000 {
            dict[i] = "item_\(i)"
        }
        RecordDuration.log(tag: tag, msg: "ready-sub-set-B")
        for i in 0..<30000 {
            dict.testSetByObjectForKey(key: i, item: "item_\(i)")
        }
        RecordDuration.log(tag: tag, msg: "ready-object-setC")
        for i in 0..<30000 {
            let _ = dict[i]
        }
        RecordDuration.log(tag: tag, msg: "ready-sub-get-D")
        for i in 0..<30000 {
            let _ = dict.testGetByObjectForKey(key: i)
        }
        RecordDuration.log(tag: tag, msg: "ready-object-get-E")
    }


}

