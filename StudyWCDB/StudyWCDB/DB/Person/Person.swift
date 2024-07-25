//
//  Person.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/25/24.
//

import Foundation
import WCDBSwift

final class Address: NSObject, TableCodable {
    var city: String?
    var street: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Address
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case city
        case street
    }
}

final class Person: NSObject, TableCodable {
    var personId: Int = 0
    var name: String?
    var age: Int = 0
    var address: Address?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Person
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case personId = "id"
        case name
        case age
        case address
    }
}
