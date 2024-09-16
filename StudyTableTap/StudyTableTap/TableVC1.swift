//
//  TableVC1.swift
//  StudyTableTap
//
//  Created by MacBook Pro on 9/12/24.
//

import UIKit

class BaseTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .plain)
        v.delegate = self
        v.dataSource = self
        v.backgroundColor = .white
        v.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
        return v
    }()
    var inputMenuView = InputMenuView()
    var dataList: [String] = ["A","B","C","D","E","F","G"]
    var titleStr: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = self.titleStr
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
        print("\(Date.systemDateStr2) updateTableHeight-start")
        let tableHeight = mainBounds.height-menuHeight
        UIView.animate(withDuration: 0.2) {
            self.tableView.frame = CGRect(x: 0, y: 0, width: mainBounds.width, height: tableHeight)
        } completion: { _ in
            print("\(Date.systemDateStr2) updateTableHeight-complete")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(Date.systemDateStr2) didSelect: \(dataList[indexPath.row])")
        self.inputMenuView.hideMenu()
    }
}
class TableVC1: BaseTableVC {
    
    override func viewDidLoad() {
        self.tableView.register(ImageCellA.self, forCellReuseIdentifier: "Cell")
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ImageCellA {
            let data = self.dataList[indexPath.row]
            cell.updateData(text: data)
            let oldFrame = cell.container.frame
            let x = (indexPath.row % 2 == 0) ? 10 : (mainBounds.width-10-containerWidth)
            cell.container.frame = CGRect(x: x, y: oldFrame.minY, width: oldFrame.width, height: oldFrame.height)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
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
        self.backgroundColor = .white
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
//        print("old: \(data ?? "") new:\(text)")
        self.data = text
        self.descLabel.text = text
    }
    
    @objc func containerClick() {
        print("\(Date.systemDateStr2) containerClick: \(data ?? "")")
    }
}
