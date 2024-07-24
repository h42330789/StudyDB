//
//  PeopleDBWorker.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/24/24.
//

import Foundation
import WCDBSwift

class PeopleDBWorker {
    let dbPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/test.db"
    var database: Database? = nil
    
    // MARK: 初始化数据库和表
    init() {
        // 初始化数据库对象
        database = Database(at: dbPath)
        do {
            // 要初始化建表（没有创建过该表就建表，已经建过表了有字段变更就做响应处理）
            try database?.create(table: PeopleDBModel.tableName, of: PeopleDBModel.self)
        } catch {
            print(error)
        }
    }
    
    // MARK: 插入数据
    func addPeoples(list: [PeopleModel]) -> Bool {
        do {
            try database?.insert(list.map{$0.dbModel}, on: PeopleDBModel.Properties.all, intoTable: PeopleDBModel.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    // MARK: 查询数据
    func selectPeoples() -> [PeopleModel]? {
        do {
            let list: [PeopleDBModel]? = try database?.getObjects(on: PeopleDBModel.Properties.all, fromTable: PeopleDBModel.tableName)
            return list?.map{ $0.bizModel }
        } catch {
            print(error)
            return nil
        }
    }

}
