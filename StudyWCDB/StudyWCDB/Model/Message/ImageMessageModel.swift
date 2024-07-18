//
//  ImageMessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
class ImageMessageModel: MediaMessageModel {
    var width: Int = 0
    var height: Int = 0
    var thumbFileName: String? = nil // 缩略图本地地址
    var thumbUrl: String? = nil // 缩略图网络地址
    
    // dict\model两种方式只需要一种
    override func encodeSubInfoDict() -> [String: Any] {
        var dict = super.encodeSubInfoDict()
        dict["width"] = width
        dict["height"] = height
        dict["thumbFileName"] = thumbFileName
        dict["thumbUrl"] = thumbUrl
        return dict
    }
    override func decodeSubInfoDict(_ dict: [String: Any]) {
        super.decodeSubInfoDict(dict)
        if let val = dict["width"] as? Int {
            width = val
        }
        if let val = dict["height"] as? Int {
            height = val
        }
        if let val = dict["thumbFileName"] as? String {
            thumbFileName = val
        }
        if let val = dict["thumbUrl"] as? String {
            thumbUrl = val
        }
    }
    
    // model -> DB
    override func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.encodeSubInfoModel(dbModel)
        dbModel.width = width
        dbModel.height = height
        dbModel.thumbFileName = thumbFileName
        dbModel.thumbUrl = thumbUrl
    }
    // DB -> model
    override func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.decodeSubInfoModel(dbModel)
        self.width = dbModel.width ?? 0
        self.height = dbModel.height ?? 0
        self.thumbFileName = dbModel.thumbFileName
        self.thumbUrl = dbModel.thumbUrl
    }
}
