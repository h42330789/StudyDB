//
//  Tool.swift
//  StudyTableTap
//
//  Created by flow on 9/14/24.
//

import Foundation
import UIKit

typealias ActionClosure = (()->Void)

func dispatchMainAfter(milliseconds: Int, action: @escaping ActionClosure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: action)
}

func dispatchGlobalAfter(milliseconds: Int, action: @escaping ActionClosure) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: action)
}

var mainBounds: CGRect {
    return UIScreen.main.bounds
}
var mainRowHeight: CGFloat {
    return 120
}
var containerWidth: CGFloat {
    return 200
}

extension Date {
    static func systemDate() -> Date {
        return Date()
    }
    static var systemDateStr: String {
        return Date.systemDate().systemDateStr
    }
    var systemDateStr: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式q1
        return dateformatter.string(from: self)
    }
    static var systemDateStr2: String {
        return Date.systemDate().systemDateStr2
    }
    var systemDateStr2: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"// 自定义时间格式q1
        return dateformatter.string(from: self)
    }
}
