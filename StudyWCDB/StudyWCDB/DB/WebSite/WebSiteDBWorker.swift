//
//  WebSiteDBWorker.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/16/24.
//

import Foundation
import WCDBSwift

class WebSiteDBWorker {
    let dbPath = PathTool.documentsDir.appendPath("/xx/xx/xx.db")
    
    init() {
        // 全局监控
        print(dbPath)
        Database.globalTraceSQL{ (tag, path, handleId, sql, info) in
//            print("Tag: \(tag)")
//            print("Path: \(path)")
//            print("The handle with id \(handleId) executed \(sql)")
//            print("Execution info \(info)")
        }

        let db = Database(at: dbPath)
        
        //监控单个数据库
        db.trace(ofPerformance: { (tag, path, handleId, sql, info) in
            print("\(info.costInNanoseconds/1000000) millseconds \(info.costInNanoseconds%1000000) nanoseconds to execute sql \(sql)");
        })
        
        do {
            // 要初始化表
            try db.create(table: WebSiteDBModel.tableName, of: WebSiteDBModel.self)
        } catch {
            print(error)
        }
    }
    
    @discardableResult
    func addWebSites(sites: [WebSiteDBModel]) -> Bool {
        let db = Database(at: dbPath)
        do {
            try db.insertOrReplace(sites, intoTable: WebSiteDBModel.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    // MARK: - 查询count数量、AVG平均数、MAX最大数、MIN最小数、SUM求和
    func getWebSitesCount() -> Int? {
        let db = Database(at: dbPath)
        do {
            let val = try db.getValue(on: WebSiteDBModel.Properties.id.count(), fromTable: WebSiteDBModel.tableName)
            return val.intValue
        } catch {
            return nil
        }
    }
    func getWebSitesCountryCount(isDistinct: Bool) -> Int? {
        let db = Database(at: dbPath)
        do {
            let val = try db.getValue(on: WebSiteDBModel.Properties.country.count(isDistinct: isDistinct), fromTable: WebSiteDBModel.tableName)
            return val.intValue
        } catch {
            return nil
        }
    }
    func getWebSitesAlexTotal() -> Int? {
        // total与sum等效，但一般sum更常用
        let db = Database(at: dbPath)
        do {
            let val = try db.getValue(on: WebSiteDBModel.Properties.alexa.total(), fromTable: WebSiteDBModel.tableName)
            return val.intValue
        } catch {
            return nil
        }
    }
    func getWebSiteAlexAvg() -> Int? {
        let db = Database(at: dbPath)
        do {
            let val = try db.getValue(on: WebSiteDBModel.Properties.alexa.avg(), fromTable: WebSiteDBModel.tableName)
            return val.intValue
        } catch {
            return nil
        }
    }
    func getWebSiteAlexMax() -> Int? {
        let db = Database(at: dbPath)
        do {
            let val = try db.getValue(on: WebSiteDBModel.Properties.alexa.max(), fromTable: WebSiteDBModel.tableName)
            return val.intValue
        } catch {
            return nil
        }
    }
    func getWebSiteAlexMin() -> Int? {
        let db = Database(at: dbPath)
        do {
            let val = try db.getValue(on: WebSiteDBModel.Properties.alexa.min(), fromTable: WebSiteDBModel.tableName)
            return val.intValue
        } catch {
            return nil
        }
    }
    func getWebSiteAlexSum() -> Int? {
        let db = Database(at: dbPath)
        do {
            let val = try db.getValue(on: WebSiteDBModel.Properties.alexa.sum(), fromTable: WebSiteDBModel.tableName)
            return val.intValue
        } catch {
            return nil
        }
    }
    // MARK: - 分页
    func getWebSites(offset: Int = 0, limit: Int? = nil) -> [WebSiteDBModel] {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let list: [WebSiteDBModel] = try db.getObjects(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, limit: 10, offset: offset)
            return list
        } catch {
            print(error)
            return []
        }
    }
    
    func getWebSite(name: String) -> WebSiteDBModel? {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let obj: WebSiteDBModel? = try db.getObject(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, where: WebSiteDBModel.Properties.name == name)
            return obj
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: - 通过BETWEEN、NOT BETWEEN 查
    /**
     BETWEEN 操作符选取介于两个值之间的数据范围内的值。这些值可以是数值、文本或者日期
     带有文本值的 BETWEEN:  xxx WHERE name BETWEEN 'A' AND 'H';
     带有数字值的 BETWEEN:  xxx  WHERE alexa NOT BETWEEN 1 AND 20;
     带有日期值的 BETWEEN:  xxx  WHERE date BETWEEN '2016-05-10' AND '2016-05-14';
     https://www.runoob.com/sql/sql-between.html
     */
    @discardableResult
    func getWebsitesNameBetween(begin: String, end: String) -> [WebSiteDBModel] {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            let list: [WebSiteDBModel] = try db.getObjects(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, where: WebSiteDBModel.Properties.name.between(begin, end))
            return list
        } catch {
            print(error)
            return []
        }
    }
    @discardableResult
    func getWebsitesAgeNotBetween(begin: Int, end: Int) -> [StudentDBModel] {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            let list: [StudentDBModel] = try db.getObjects(on: StudentDBModel.Properties.all, fromTable: StudentDBModel.tableName, where: StudentDBModel.Properties.age.notBetween(begin, end))
            return list
        } catch {
            print(error)
            return []
        }
    }
    // MARK: 通过IN、NOT IN 查
    /**
     IN 操作符选取在某个集合里
     https://www.runoob.com/sql/sql-in.html
     */
    @discardableResult
    func getWebsitesNamesIn(names: [String]) -> [WebSiteDBModel] {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            let list: [WebSiteDBModel] = try db.getObjects(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, where: WebSiteDBModel.Properties.name.in(names))
            return list
        } catch {
            print(error)
            return []
        }
    }
    @discardableResult
    func getWebsitesAlexaNotIn(alexas: [Int]) -> [WebSiteDBModel] {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            let list: [WebSiteDBModel] = try db.getObjects(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, where: WebSiteDBModel.Properties.alexa.notIn(alexas))
            return list
        } catch {
            print(error)
            return []
        }
    }
    // MARK: IN、BETWEEN一起
    @discardableResult
    func getWebsitesAlexaBetweenCountryNotIn(begin: Int, end: Int, countrys: [String]) -> [WebSiteDBModel] {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            let list: [WebSiteDBModel] = try db.getObjects(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, where: WebSiteDBModel.Properties.alexa.between(begin, end) && WebSiteDBModel.Properties.country.notIn(countrys) )
            return list
        } catch {
            print(error)
            return []
        }
    }
    // MARK: - 模糊匹配 LIKE+regexp+match+glob
    // MARK: LIKE 查，通配符支持%: 代替0个多多个字符， _: 代表一个字符
    /**
     https://www.runoob.com/sql/sql-like.html
     "%" 符号用于在模式的前后定义通配
     WHERE name LIKE 'G%'; 以G开头
     WHERE name LIKE '%k'; 以k结尾
     WHERE name LIKE '%oo%'; 包含oo
     */
    @discardableResult
    func getWebsitesNameLike(likeExp: String) -> [WebSiteDBModel] {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            let list: [WebSiteDBModel] = try db.getObjects(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, where: WebSiteDBModel.Properties.name.like(likeExp))
            return list
        } catch {
            print(error)
            return []
        }
    }
    // MARK: REGEXP 查，通配符支持%: 代替0个多多个字符， _: 代表一个字符
    /**
     https://www.runoob.com/sql/sql-wildcards.html
     表达式
     */
    @discardableResult
    func getWebsitesNameREGEXP(regExp: String) -> [WebSiteDBModel] {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            let list: [WebSiteDBModel] = try db.getObjects(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, where: WebSiteDBModel.Properties.name.regexp(regExp))
            return list
        } catch {
            print(error)
            return []
        }
    }
}
