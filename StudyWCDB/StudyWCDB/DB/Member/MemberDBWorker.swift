//
//  MemberDBWorker.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/25/24.
//

import Foundation
import WCDBSwift

class MemberDBWorker {
    let dbPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/test.db"
    var database: Database? = nil
    
    // MARK: 初始化数据库和表
    init() {
        // 初始化数据库对象
        database = Database(at: dbPath)
        do {
            //监控单个数据库
            database?.trace(ofPerformance: { (tag, path, handleId, sql, info) in
                print(path)
                print("\(info.costInNanoseconds/1000000) millseconds \(info.costInNanoseconds%1000000) nanoseconds to execute sql \(sql)");
            })
            // 要初始化建表（没有创建过该表就建表，已经建过表了有字段变更就做响应处理）
            try database?.create(table: GroupMemberDBModel.tableName, of: GroupMemberDBModel.self)
        } catch {
            print(error)
        }
    }
    
    // MARK: 插入数据
    func addMembers(list: [GroupMemberInfo]) -> Bool {
        do {
            let dbList = list.map{$0.dbModel}
            try database?.insert(dbList, on: GroupMemberDBModel.Properties.all, intoTable: GroupMemberDBModel.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    // MARK: 查询数据
    func allMembers() -> [GroupMemberInfo]? {
        do {
            let list: [GroupMemberDBModel]? = try database?.getObjects(on: GroupMemberDBModel.Properties.all, fromTable: GroupMemberDBModel.tableName)
            return list?.map{ $0.bizModel }
        } catch {
            print(error)
            return nil
        }
    }
    func searchMember(remarkName: String) -> [GroupMemberInfo]? {
        do {
            let list: [GroupMemberDBModel]? = try database?.getObjects(on: GroupMemberDBModel.Properties.all, fromTable: GroupMemberDBModel.tableName, where: GroupMemberDBModel.Properties.remarkName.like("%\(remarkName)%"))
            return list?.map{ $0.bizModel }
        } catch {
            print(error)
            return nil
        }
    }
    @discardableResult
    func deleteAll() -> Bool {
        do {
            try database?.delete(fromTable: GroupMemberDBModel.tableName)
            return true
        } catch {
            print(error)
            return false
        }
    }
    func update(info: GroupMemberInfo) -> Bool {
        do {
            try database?.update(table: GroupMemberDBModel.tableName, on: GroupMemberDBModel.Properties.all, with: [info.dbModel])
            return true
        } catch {
            print(error)
            return false
        }
    }
    func update(infos: [GroupMemberInfo]) -> Bool {
        do {
            try database?.update(table: GroupMemberDBModel.tableName, on: GroupMemberDBModel.Properties.all, with: infos.map {$0.dbModel})
            return true
        } catch {
            print(error)
            return false
        }
    }

}
