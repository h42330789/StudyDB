//
//  TableVC3.swift
//  StudyTableTap
//
//  Created by flow on 9/14/24.
//

import UIKit

class TableVC3: BaseTableVC {
    
    override func viewDidLoad() {
        self.tableView.register(ImageCellC.self, forCellReuseIdentifier: "Cell")
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ImageCellC {
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

class ImageCellC: UITableViewCell {
    let container = UIView()
    let descLabel = UILabel()
    var data: String? = nil
    var tapGesture: UITapGestureRecognizer? = nil
    
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
        self.tapGesture = tapGesture
        container.addGestureRecognizer(tapGesture)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containerDoubleTapClick))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        container.addGestureRecognizer(doubleTapGestureRecognizer)
        tapGesture.require(toFail: doubleTapGestureRecognizer)
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(containerLongPress(_:)))
        container.addGestureRecognizer(longPressGesture)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(Date.systemDateStr2) touchesEnded: \(data ?? "")")
        if let tapGe = self.tapGesture, tapGe.isEnabled {
            // 存在tapGesture才处理，否则没有意义
            for touch in touches {
                let point = touch.location(in: self)
                let cPoint = self.convert(point, to: container)
                if let _ = container.hitTest(cPoint, with: event) {
                    if let data = data, let tapG = findContainerTapGes(touch: touch) {
                        dispatchMainAfter(milliseconds: 1, action: {[weak self] in
                            self?.containerTapClick2(tapG, data: data)
                        })
                    }
                    break
                }
            }
        }
        super.touchesEnded(touches, with: event)
    }
    func findContainerTapGes(touch: UITouch) -> UITapGestureRecognizer? {
        guard let gesList = touch.gestureRecognizers, gesList.count > 0 else {
            return nil
        }
        for ges in gesList {
            if let tapG = ges as? UITapGestureRecognizer, tapG == self.tapGesture {
                return tapG
            }
        }
        return nil
    }
    
    func updateData(text: String) {
//        print("old: \(data ?? "") new:\(text)")
        self.data = text
        self.descLabel.text = text
    }
    
    @objc func containerTapClick() {
        print("\(Date.systemDateStr2) containerTapClick: \(data ?? "")")
    }
    func containerTapClick2(_ gesture: UITapGestureRecognizer, data: String) {
        print("\(Date.systemDateStr2) containerTapClick2: \(data)")
    }
    
    @objc func containerDoubleTapClick() {
        print("\(Date.systemDateStr2) containerDoubleTapClick: \(data ?? "")")
    }
    
    @objc func containerLongPress(_ gesture: UILongPressGestureRecognizer) {
        print("\(Date.systemDateStr2) containerLongPress: \(data ?? "")")
    }
}

