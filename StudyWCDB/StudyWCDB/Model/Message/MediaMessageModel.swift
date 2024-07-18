//
//  MediaMessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation

class MediaMessageModel: MessageModel {
    var fileSize: Int64 = 0 // 文件大小
    var fileName: String? = nil // 多媒体附件本地地址
    var url: String? = nil // 多媒体附件网络地址
    
    // dict\model两种方式只需要一种
    override func encodeSubInfoDict() -> [String: Any] {
        var dict = super.encodeSubInfoDict()
        dict["fileSize"] = fileSize
        dict["fileName"] = fileName
        dict["url"] = url
        return dict
    }
    override func decodeSubInfoDict(_ dict: [String: Any]) {
        super.decodeSubInfoDict(dict)
        if let val = dict["fileSize"] as? Int64 {
            fileSize = val
        }
        if let val = dict["fileName"] as? String {
            fileName = val
        }
        if let val = dict["url"] as? String {
            url = val
        }
    }
    
    // model -> DB
    override func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.encodeSubInfoModel(dbModel)
        dbModel.fileSize = fileSize
        dbModel.fileName = fileName
        dbModel.url = url
    }
    // DB -> model
    override func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.decodeSubInfoModel(dbModel)
        self.fileSize = dbModel.fileSize ?? 0
        self.fileName = dbModel.fileName
        self.url = dbModel.url
    }
}
