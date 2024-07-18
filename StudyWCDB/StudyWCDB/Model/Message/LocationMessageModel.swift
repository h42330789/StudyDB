//
//  LocationMessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
class LocationMessageModel: MessageModel {
    var lat: Int32 = 0
    var lng: Int32 = 0
    var address: String = ""
    
    // dict\model两种方式只需要一种
    override func encodeSubInfoDict() -> [String: Any] {
        var dict = super.encodeSubInfoDict()
        dict["lat"] = lat
        dict["lng"] = lng
        dict["address"] = address
        return dict
    }
    override func decodeSubInfoDict(_ dict: [String: Any]) {
        super.decodeSubInfoDict(dict)
        if let val = dict["lat"] as? Int32 {
            lat = val
        }
        if let val = dict["lng"] as? Int32 {
            lng = val
        }
        if let val = dict["address"] as? String {
            address = val
        }
    }
    
    // model -> DB
    override func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.encodeSubInfoModel(dbModel)
        dbModel.lat = lat
        dbModel.lng = lng
        dbModel.address = address
    }
    // DB -> model
    override func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.decodeSubInfoModel(dbModel)
        self.lat = dbModel.lat ?? 0
        self.lng = dbModel.lng ?? 0
        self.address = dbModel.address ?? ""
    }
}
