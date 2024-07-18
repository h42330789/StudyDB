//
//  JsonTool.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
extension Dictionary {
    func jsonString() -> String? {
        let object = self as NSDictionary
        if let data = try? JSONSerialization.data(withJSONObject: object, options: []) {
            return String(data: data, encoding: String.Encoding.utf8)
        } else {
            return nil
        }
    }
    func jsonData() -> Data? {
        let object = self as NSDictionary
        if let data = try? JSONSerialization.data(withJSONObject: object, options: []) {
            return data
        } else {
            return nil
        }
    }
}

extension Array {
    func jsonString() -> String? {
        let object = self as NSArray
        if let data = try? JSONSerialization.data(withJSONObject: object, options: []) {
            return String(data: data, encoding: String.Encoding.utf8)
        } else {
            return nil
        }
    }
    func jsonData() -> Data? {
        let object = self as NSArray
        if let data = try? JSONSerialization.data(withJSONObject: object, options: []) {
            return data
        } else {
            return nil
        }
    }
}
extension String {
    func jsonValue() -> Any? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        guard let result = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        
        return result as Any
    }
    func jsonData() -> Data? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data
    }
}

extension Data {
    func jsonValue() -> Any? {
        guard let result = try? JSONSerialization.jsonObject(with: self, options: []) else {
            return nil
        }
        
        return result as Any
    }
}
