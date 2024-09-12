//
//  ViewController.swift
//  StudySafeDict
//
//  Created by MacBook Pro on 8/12/24.
//

import UIKit
import WebKit

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
        
        let webView = WKWebView(frame: CGRect(x: 10, y: 50, width: 200, height: 300))
        webView.backgroundColor = .orange
        if #available(iOS 16.4,*) {
            webView.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: "https://www.google.com")!))
    }


}

