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
        } catch {
            print(error)
        }
    }
    
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
    
    // MARK: -
    @discardableResult
    func addMessages(msgs: [MessageDBModel]) -> Bool {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            try db.insertOrReplace(msgs, intoTable: MessageDBModel.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    func getMessages() -> [MessageDBModel] {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let list: [MessageDBModel] = try db.getObjects(on: MessageDBModel.Properties.all, fromTable: MessageDBModel.tableName)
            return list
        } catch {
            print(error)
            return []
        }
    }
}
