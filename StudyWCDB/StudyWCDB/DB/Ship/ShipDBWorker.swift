//
//  ShipDBWorker.swift
//  StudyWCDB
//
//  Created by flow on 7/26/24.
//

import Foundation
import WCDBSwift

class ShipDBWorker {
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
            try database?.create(table: ShipDBModel.tableName, of: ShipDBModel.self)
            try database?.create(table: ShipDBModel2.tableName, of: ShipDBModel2.self)
        } catch {
            print(error)
        }
    }
    
    // MARK: - 插入数据
    func addList(list: [ShipModel]) -> Bool {
        do {
            let dbList = list.map{$0.dbModel}
            try database?.insert(dbList, on: ShipDBModel.Properties.all, intoTable: ShipDBModel.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    // MARK: 查询数据
    func allList() -> [ShipModel]? {
        do {
            let list: [ShipDBModel]? = try database?.getObjects(on: ShipDBModel.Properties.all, fromTable: ShipDBModel.tableName)
            return list?.map{ $0.bizModel }
        } catch {
            print(error)
            return nil
        }
    }
    func searchModel(brand: String) -> [ShipModel]? {
        do {
            // SQL:SELECT id, name, color, engin FROM ships WHERE brand LIKE '%Air%',Message:no such column: brand,Source:SQLite
            let list: [ShipDBModel]? = try database?.getObjects(on: ShipDBModel.Properties.all, fromTable: ShipDBModel.tableName, where: EngineDBModel.Properties.brand.like("%\(brand)%"))
            return list?.map{ $0.bizModel }
        } catch {
            print(error)
            return nil
        }
    }
    // MARK: - 插入数据
    func addList2(list: [ShipModel]) -> Bool {
        do {
            let dbList = list.map{$0.dbModel2}
            try database?.insert(dbList, on: ShipDBModel2.Properties.all, intoTable: ShipDBModel2.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    // MARK: 查询数据
    func allList2() -> [ShipModel]? {
        do {
            let list: [ShipDBModel2]? = try database?.getObjects(on: ShipDBModel2.Properties.all, fromTable: ShipDBModel2.tableName)
            return list?.map{ $0.bizModel }
        } catch {
            print(error)
            return nil
        }
    }
    func searchModel2(brand: String) -> [ShipModel]? {
        do {
            let list: [ShipDBModel2]? = try database?.getObjects(on: ShipDBModel2.Properties.all, fromTable: ShipDBModel2.tableName, where: ShipDBModel2.Properties.enginBrand.like("%\(brand)%"))
            return list?.map{ $0.bizModel }
        } catch {
            print(error)
            return nil
        }
    }
}
