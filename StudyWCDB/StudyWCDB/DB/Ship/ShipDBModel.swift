//
//  ShipDBModel.swift
//  StudyWCDB
//
//  Created by flow on 7/26/24.
//

import Foundation
import WCDBSwift

final class ShipDBModel: TableCodable {
    var id: Int?
    var name: String?
    var color: String?
    var engin: EngineModel?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ShipDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case id
        case name
        case color
        case engin
    }
    
    static var tableName: String {
        return "ships"
    }
}
final class EngineDBModel: TableCodable {
    var brand: String?
    var price: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = EngineDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case brand
        case price
    }
}
extension EngineModel: ColumnJSONCodable {
    enum CodingKeys: String, CodingKey {
        case brand
        case price
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brand, forKey: .brand)
        try container.encode(price, forKey: .price)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        brand = try container.decode(String.self, forKey: .brand)
        price = try container.decode(Double.self, forKey: .price)

    }
}
