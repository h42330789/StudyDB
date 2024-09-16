//
//  ShipDBModel2.swift
//  StudyWCDB
//
//  Created by flow on 7/26/24.
//

import Foundation
import WCDBSwift

final class ShipDBModel2: TableCodable {
    var id: Int?
    var name: String?
    var color: String?
    var engin: EngineModel? {
        didSet {
            self.enginBrand = engin?.brand
        }
    }
    private var enginBrand: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ShipDBModel2
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case id
        case name
        case color
        case engin
        case enginBrand
    }
    
    static var tableName: String {
        return "ships2"
    }
}
