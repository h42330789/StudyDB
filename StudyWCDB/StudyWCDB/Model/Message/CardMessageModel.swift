//
//  CardMessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
class CardMessageModel: MessageModel {
    var cardUid: Int64 = 0
    var cardName: String = ""
    var cardIcon: String = ""
    var cardId: String = ""
    
    // dict\model两种方式只需要一种
    override func encodeSubInfoDict() -> [String: Any] {
        var dict = super.encodeSubInfoDict()
        dict["cardUid"] = cardUid
        dict["cardName"] = cardName
        dict["cardIcon"] = cardIcon
        dict["cardId"] = cardId
        return dict
    }
    override func decodeSubInfoDict(_ dict: [String: Any]) {
        super.decodeSubInfoDict(dict)
        if let val = dict["cardUid"] as? Int64 {
            cardUid = val
        }
        if let val = dict["cardName"] as? String {
            cardName = val
        }
        if let val = dict["cardIcon"] as? String {
            cardIcon = val
        }
        if let val = dict["cardId"] as? String {
            cardId = val
        }
    }
    
    // model -> DB
    override func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.encodeSubInfoModel(dbModel)
        dbModel.cardUid = cardUid
        dbModel.cardName = cardName
        dbModel.cardIcon = cardIcon
        dbModel.cardId = cardId
    }
    // DB -> model
    override func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.decodeSubInfoModel(dbModel)
        self.cardUid = dbModel.cardUid ?? 0
        self.cardName = dbModel.cardName ?? ""
        self.cardIcon = dbModel.cardIcon ?? ""
        self.cardId = dbModel.cardId ?? ""
    }
}
