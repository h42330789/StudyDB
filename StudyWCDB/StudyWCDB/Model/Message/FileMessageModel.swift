//
//  FileMessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
class FileMessageModel: MediaMessageModel {
    var mimeType: String = ""
    var localFileName: String? = nil
    
    // dict\model两种方式只需要一种
    override func encodeSubInfoDict() -> [String: Any] {
        var dict = super.encodeSubInfoDict()
        dict["mimeType"] = mimeType
        dict["localFileName"] = localFileName
        return dict
    }
    override func decodeSubInfoDict(_ dict: [String: Any]) {
        super.decodeSubInfoDict(dict)
        if let val = dict["mimeType"] as? String {
            mimeType = val
        }
        if let val = dict["localFileName"] as? String {
            localFileName = val
        }
    }
    
    // model -> DB
    override func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.encodeSubInfoModel(dbModel)
        dbModel.mimeType = mimeType
        dbModel.localFileName = localFileName
    }
    // DB -> model
    override func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.decodeSubInfoModel(dbModel)
        self.mimeType = dbModel.mimeType ?? ""
        self.localFileName = dbModel.localFileName
    }
}
