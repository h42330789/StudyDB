//
//  VideoMessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
class VideoMessageModel: MediaMessageModel {
    var compressed: Bool = true
    
    // dict\model两种方式只需要一种
    override func encodeSubInfoDict() -> [String: Any] {
        var dict = super.encodeSubInfoDict()
        dict["compressed"] = compressed
        return dict
    }
    override func decodeSubInfoDict(_ dict: [String: Any]) {
        super.decodeSubInfoDict(dict)
        if let val = dict["compressed"] as? Bool {
            compressed = val
        }
    }
    
    // model -> DB
    override func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.encodeSubInfoModel(dbModel)
        dbModel.compressed = compressed
    }
    // DB -> model
    override func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.decodeSubInfoModel(dbModel)
        self.compressed = dbModel.compressed ?? true
    }
}
