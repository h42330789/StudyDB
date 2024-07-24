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
    
    // MARK: - 复杂组合查询
    func searchWebsites(keywords: String?, inUids: [Int64]? = nil, idStart: Int64? = nil, idEnd: Int64? = nil, notInIds:[Int64]? = nil, pageSize: Int? = nil, pageNum: Int? = nil) -> [WebSiteDBModel]? {
        // 多查询条件组合
        var exps: [Expression] = []
        // 如果存在关键字
        if let words = keywords, words.count > 0 {
            let exp1 = WebSiteDBModel.Properties.name.like("%\(words)%")
            if let inUids = inUids, inUids.count > 0 {
                let exp2 = WebSiteDBModel.Properties.id.in(inUids)
                exps.append(exp1 || exp2)
            } else {
                exps.append(exp1)
            }
        }
        // 如果存在start\end
        if let start = idStart, let end = idEnd {
            exps.append(WebSiteDBModel.Properties.id.between(start, end))
        }
        // 如果存在notInIds
        if let notInIds = notInIds, notInIds.count > 0 {
            exps.append(WebSiteDBModel.Properties.id.notIn(notInIds))
        }
        // 将所有条件按&&组合起来
        var conditions: Expression? = nil
        for exp in exps {
            if let preExp = conditions {
                conditions = preExp && exp
            } else {
                conditions = exp
            }
        }
        // 2、组合排序规则
        var orderBys: [OrderingTerm] = []
        orderBys.append(WebSiteDBModel.Properties.name.order(.ascending))
        orderBys.append(WebSiteDBModel.Properties.alexa.order(.descending))
        // 3、分页
        var offset: Int? = nil
        if let pageNum = pageNum, pageNum > 0,
           let pageSize = pageSize, pageSize > 0 {
            offset = pageNum*pageSize
        }
        // 真正查询
        let db = Database(at: dbPath)
        do {
            let objs: [WebSiteDBModel] = try db.getObjects(on: WebSiteDBModel.Properties.all, fromTable: WebSiteDBModel.tableName, where: conditions, orderBy: orderBys, limit: pageSize, offset: offset)
            return objs
        } catch {
            print(error)
            return nil
        }
    }
}
