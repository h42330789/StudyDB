//
//  TableVC4.swift
//  StudyTableTap
//
//  Created by flow on 9/14/24.
//

import UIKit

class TableVC4: BaseTableVC {
    
    override func viewDidLoad() {
        self.tableView.register(ImageCellD.self, forCellReuseIdentifier: "Cell")
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ImageCellD {
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

class ImageCellD: UITableViewCell {
    let container = UIView()
    let descLabel = UILabel()
    var data: String? = nil
    var touchData: String? = nil
    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapClick))
        container.addGestureRecognizer(tapGesture)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containerDoubleTapClick))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        container.addGestureRecognizer(doubleTapGestureRecognizer)
        tapGesture.require(toFail: doubleTapGestureRecognizer)
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(containerLongPress(_:)))
        container.addGestureRecognizer(longPressGesture)
    }
    
    func updateData(text: String) {
//        print("old: \(data ?? "") new:\(text)")
        self.data = text
        self.descLabel.text = text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchData = nil
        print("\(Date.systemDateStr2) touchesBegan: \(data ?? "")")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(Date.systemDateStr2) touchesEnded: \(data ?? "")")
        self.touchData = data
        super.touchesEnded(touches, with: event)
    }
    
    @objc func containerTapClick() {
        print("\(Date.systemDateStr2) containerTapClick: touchData:\(touchData ?? "") data:\(data ?? "")")
        self.touchData = nil
    }
    
    @objc func containerDoubleTapClick() {
        print("\(Date.systemDateStr2) containerDoubleTapClick: touchData:\(touchData ?? "") data:\(data ?? "")")
        self.touchData = nil
    }
    
    @objc func containerLongPress(_ gesture: UILongPressGestureRecognizer) {
        print("\(Date.systemDateStr2) containerLongPress: touchData:\(touchData ?? "") data:\(data ?? "")")
        self.touchData = nil
    }
}
