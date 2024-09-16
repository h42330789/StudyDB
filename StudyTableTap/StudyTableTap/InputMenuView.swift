//
//  InputMenuView.swift
//  StudyTableTap
//
//  Created by flow on 9/14/24.
//

import UIKit
class InputMenuView: UIView {
    let showBtn = UIButton(type: .custom)
    let sendBtn = UIButton(type: .custom)
    var isShowing = false
    
    typealias ShowBlock = (CGFloat) -> Void
    typealias SendBlock = (String) -> Void
    var showOrCloseBlock: ShowBlock? = nil
    var sendBlock: SendBlock? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSelf() {
        self.backgroundColor = .white
        showBtn.setTitleColor(.black, for: .normal)
        showBtn.setTitle("open", for: .normal)
        showBtn.backgroundColor = .systemBlue
        showBtn.frame = CGRect(x: 40, y: 10, width: 50, height: 30)
        showBtn.addTarget(self, action: #selector(showBtnClick), for: .touchUpInside)
        self.addSubview(showBtn)
        self.backgroundColor = .brown
        
        sendBtn.setTitleColor(.black, for: .normal)
        sendBtn.setTitle("send", for: .normal)
        sendBtn.backgroundColor = .systemBlue
        sendBtn.frame = CGRect(x: 40, y: 60, width: 50, height: 30)
        sendBtn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        self.addSubview(sendBtn)
    }
    
    @objc func showBtnClick() {
        self.isShowing = !isShowing
        changeShow()
    }
    func hideMenu() {
        if self.isShowing == false {
            return
        }
        self.isShowing = false
        changeShow()
    }
    func changeShow() {
        var totalHeight: CGFloat = 50
        if self.isShowing {
            totalHeight = totalHeight + 200
        }
        showBtn.setTitle(isShowing ? "close" : "open", for: .normal)
        let y = mainBounds.height - totalHeight
        print("\(Date.systemDateStr2) showBtnClick-\(isShowing ? "open" : "close")-start")
        UIView.animate(withDuration: 0.2) {
            self.frame = CGRect(x: 0, y: y, width: mainBounds.width, height: totalHeight)
        } completion: { _ in
            print("\(Date.systemDateStr2) showBtnClick-\(self.isShowing ? "open" : "close")-complete")
        }
        showOrCloseBlock?(totalHeight)
    }
    
    @objc func sendBtnClick() {
        sendBlock?("send-\(Int.random(in: 0...999))")
    }
}
