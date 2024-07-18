//
//  NoticeMessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
class NoticeMessageModel: MessageModel {
    var noticeId: Int64 = 0
    var showNotify: Bool = false
    
    // dict\model两种方式只需要一种
    override func encodeSubInfoDict() -> [String: Any] {
        var dict = super.encodeSubInfoDict()
        dict["noticeId"] = noticeId
        dict["showNotify"] = showNotify
        return dict
    }
    override func decodeSubInfoDict(_ dict: [String: Any]) {
        super.decodeSubInfoDict(dict)
        if let val = dict["noticeId"] as? Int64 {
            noticeId = val
        }
        if let val = dict["showNotify"] as? Bool {
            showNotify = val
        }
    }
    
    // model -> DB
    override func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.encodeSubInfoModel(dbModel)
        dbModel.noticeId = noticeId
        dbModel.showNotify = showNotify
    }
    // DB -> model
    override func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.decodeSubInfoModel(dbModel)
        self.noticeId = dbModel.noticeId ?? 0
        self.showNotify = dbModel.showNotify ?? false
    }
}
