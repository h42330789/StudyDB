//
//  ShipModel.swift
//  StudyWCDB
//
//  Created by flow on 7/26/24.
//

import Foundation

struct EngineModel {
    var brand: String = ""
    var price: Double = 0
}

struct ShipModel {
    var id: Int = 0
    var name: String = ""
    var color: String = ""
    var engin: EngineModel = EngineModel()
}

extension ShipModel {
    var dbModel: ShipDBModel {
        let dbModel = ShipDBModel()
        dbModel.id = id
        dbModel.name = name
        dbModel.color = color
        dbModel.engin = engin
        return dbModel
    }
    var dbModel2: ShipDBModel2 {
        let dbModel = ShipDBModel2()
        dbModel.id = id
        dbModel.name = name
        dbModel.color = color
        dbModel.engin = engin
        return dbModel
    }
}
extension ShipDBModel {
    var bizModel: ShipModel {
        var model = ShipModel()
        if let val = id {
            model.id = val
        }
        if let val = name {
            model.name = val
        }
        if let val = color {
            model.color = val
        }
        if let val = engin {
            model.engin = val
        }
        return model
    }
}
extension ShipDBModel2 {
    var bizModel: ShipModel {
        var model = ShipModel()
        if let val = id {
            model.id = val
        }
        if let val = name {
            model.name = val
        }
        if let val = color {
            model.color = val
        }
        if let val = engin {
            model.engin = val
        }
        return model
    }
}
