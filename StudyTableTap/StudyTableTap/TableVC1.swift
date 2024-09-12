//
//  TableVC1.swift
//  StudyTableTap
//
//  Created by MacBook Pro on 9/12/24.
//

import UIKit
var mainBounds: CGRect {
    return UIScreen.main.bounds
}
var mainRowHeight: CGFloat {
    return 120
}
var containerWidth: CGFloat {
    return 200
}
class TableVC1: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .plain)
        v.delegate = self
        v.dataSource = self
        v.register(ImageCellA.self, forCellReuseIdentifier: "ImageCellA")
        return v
    }()
    var inputMenuView = InputMenuView()
    var dataList: [String] = ["A","B","C","D","E"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        inputMenuView.frame = CGRect(x: 0, y: mainBounds.height-50, width: mainBounds.width, height: 50)
        let tableHeight = mainBounds.height-inputMenuView.bounds.height
        tableView.frame = CGRect(x: 0, y: 0, width: mainBounds.width, height: tableHeight)
        self.view.addSubview(tableView)
        self.view.addSubview(inputMenuView)
        
        inputMenuView.showOrCloseBlock = {[weak self] menuHeight in
            self?.updateTableHeight(menuHeight: menuHeight)
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: (self?.dataList.count ?? 0) - 1, section: 0), at: .bottom, animated: true)
        }
        inputMenuView.sendBlock = {[weak self] text in
            self?.dataList.append(text)
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: (self?.dataList.count ?? 0) - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func updateTableHeight(menuHeight: CGFloat) {
        print("updateTableHeight-start")
        let tableHeight = mainBounds.height-menuHeight
        UIView.animate(withDuration: 0.2) {
            self.tableView.frame = CGRect(x: 0, y: 0, width: mainBounds.width, height: tableHeight)
        } completion: { _ in
            print("updateTableHeight-complete")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainRowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCellA", for: indexPath) as? ImageCellA {
            let data = self.dataList[indexPath.row]
            cell.updateData(text: data)
            let oldFrame = cell.container.frame
            let x = (indexPath.row % 2 == 0) ? 10 : (mainBounds.width-10-containerWidth)
            cell.container.frame = CGRect(x: x, y: oldFrame.minY, width: oldFrame.width, height: oldFrame.height)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCellA", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect: \(dataList[indexPath.row])")
        self.inputMenuView.hideMenu()
    }
}

class ImageCellA: UITableViewCell {
    let container = UIView()
    let descLabel = UILabel()
    var data: String? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.initSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSelf() {
        container.backgroundColor = .lightGray
        let fullWidth = mainBounds.width
        let padding: CGFloat = 10
        container.frame = CGRectMake(fullWidth-padding-containerWidth, padding, containerWidth, mainRowHeight-padding*2)
        self.contentView.addSubview(container)
        
        descLabel.textColor = .black
        descLabel.frame = CGRect(x: 20, y: 20, width: 100, height: 30)
        container.addSubview(descLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerClick))
        container.addGestureRecognizer(tap)
    }
    
    func updateData(text: String) {
        print("old: \(data ?? "") new:\(text)")
        self.data = text
        self.descLabel.text = text
    }
    
    @objc func containerClick() {
        print("containerClick: \(data ?? "")")
    }
}

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
        print("showBtnClick-start")
        UIView.animate(withDuration: 0.2) {
            self.frame = CGRect(x: 0, y: y, width: mainBounds.width, height: totalHeight)
        } completion: { _ in
            print("showBtnClick-complete")
        }
        showOrCloseBlock?(totalHeight)
    }
    
    @objc func sendBtnClick() {
        sendBlock?("send-\(Int.random(in: 0...999))")
    }
}
