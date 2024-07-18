//
//  MessageDBWorker.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/17/24.
//

import Foundation
import WCDBSwift

class MessageDBWorker {
    let dbPath = PathTool.documentsDir.appendPath("/xx/xx/xx.db")
    
    init() {
        print(dbPath)
        let db = Database(at: dbPath)
        do {
            //监控单个数据库
            db.trace(ofPerformance: { (tag, path, handleId, sql, info) in
                print("\(info.costInNanoseconds/1000000) millseconds \(info.costInNanoseconds%1000000) nanoseconds to execute sql \(sql)");
            })
            // 要初始化表
            try db.create(table: MessageDBModel.tableName, of: MessageDBModel.self)
            try db.create(table: MessageDBModel2.tableName, of: MessageDBModel2.self)
            try db.create(table: MessageDBModel3.tableName, of: MessageDBModel3.self)
        } catch {
            print(error)
        }
    }
    
    // MARK: - MessageDB-sub-Data
    @discardableResult
    func getMsgCount() -> Int? {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let val = try db.getValue(on: MessageDBModel.Properties.msgId.count(), fromTable: MessageDBModel.tableName)
            return val.intValue
        } catch {
            print(error)
            return nil
        }
    }
    
    @discardableResult
    func addMessages(msgs: [MessageModel]) -> Bool {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            try db.insertOrReplace(msgs.map{ $0.dbModel }, intoTable: MessageDBModel.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    func getMessages() -> [MessageModel] {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let list: [MessageDBModel] = try db.getObjects(on: MessageDBModel.Properties.all, fromTable: MessageDBModel.tableName)
            return list.map { $0.model }
        } catch {
            print(error)
            return []
        }
    }
    // MARK: - MessageDB-sub-String
    @discardableResult
    func getMsgCount2() -> Int? {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let val = try db.getValue(on: MessageDBModel2.Properties.msgId.count(), fromTable: MessageDBModel2.tableName)
            return val.intValue
        } catch {
            print(error)
            return nil
        }
    }
    @discardableResult
    func addMessages2(msgs: [MessageModel]) -> Bool {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            try db.insertOrReplace(msgs.map{ $0.dbModel2 }, intoTable: MessageDBModel2.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    func getMessages2() -> [MessageModel] {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let list: [MessageDBModel2] = try db.getObjects(on: MessageDBModel2.Properties.all, fromTable: MessageDBModel2.tableName)
            return list.map { $0.model }
        } catch {
            print(error)
            return []
        }
    }
    // MARK: - MessageDB-sub-字段
    @discardableResult
    func getMsgCount3() -> Int? {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let val = try db.getValue(on: MessageDBModel3.Properties.msgId.count(), fromTable: MessageDBModel3.tableName)
            return val.intValue
        } catch {
            print(error)
            return nil
        }
    }
    @discardableResult
    func addMessages3(msgs: [MessageModel]) -> Bool {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            try db.insertOrReplace(msgs.map{ $0.dbModel3 }, intoTable: MessageDBModel3.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    func getMessages3() -> [MessageModel] {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let list: [MessageDBModel3] = try db.getObjects(on: MessageDBModel3.Properties.all, fromTable: MessageDBModel3.tableName)
            return list.map { $0.model }
        } catch {
            print(error)
            return []
        }
    }
}
