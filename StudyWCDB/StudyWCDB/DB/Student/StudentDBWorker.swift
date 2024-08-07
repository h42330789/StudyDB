//
//  StudentDBWorker.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/16/24.
//

import Foundation
import WCDBSwift

class StudentDBWorker {
    let dbPath = PathTool.documentsDir.appendPath("/xx/xx/xx.db")
    
    init() {
        print(dbPath)
        let db = Database(at: dbPath)
        do {
            //监控单个数据库
            db.trace(ofPerformance: { (tag, path, handleId, sql, info) in
                //print("\(info.costInNanoseconds/1000000) millseconds \(info.costInNanoseconds%1000000) nanoseconds to execute sql \(sql)");
            })
            // 要初始化表
            try db.create(table: StudentDBModel.tableName, of: StudentDBModel.self)
            try db.create(table: ScoreDBModel.tableName, of: ScoreDBModel.self)
        } catch {
            print(error)
        }
    }
    
    @discardableResult
    func getStuCount() -> Int? {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            let val = try db.getValue(on: StudentDBModel.Properties.id.count(), fromTable: StudentDBModel.tableName)
            return val.intValue
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: -
    @discardableResult
    func addStus(stus: [StudentDBModel]) -> Bool {
        let db = Database(at: dbPath)
        do {
            // 没有on就是全量字段插入
            try db.insertOrReplace(stus, intoTable: StudentDBModel.tableName)
        } catch {
            print(error)
            return false
        }
        return true
    }
    @discardableResult
    func addScore(scores: [ScoreDBModel]) -> Bool {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            // 没有on就是全量字段插入
            try db.insertOrReplace(scores, intoTable: ScoreDBModel.tableName)
            return true
        } catch {
            print(error)
            return false
        }
    }
    // MARK: - 使用原生SQL
    func selectBySql1() {
        let db = Database(at: dbPath)
        do {
            // 1、准备sql语句，由于会自动拼接SELECT,需要将手写的SELECT去掉
            let sql = "SELECT Score_Table.identifier, Score_Table.stuId, Score_Table.score FROM Score_Table".replacingOccurrences(of: "SELECT", with: "")
            let statementSelect = StatementSelect().select(Column(named: sql))
            // 执行查询
            let handle = try db.getHandle()
            try handle.prepare(statementSelect)
            // 获取查询结果
            while try handle.step() {
                let val0 = handle.value(atIndex: 0).intValue
                let val1 = handle.value(atIndex: 1).intValue
                let val2 = handle.value(atIndex: 2).doubleValue
                print("selectBySql1 identifier:\(val0) stuId:\(val1) score:\(val2)")
            }
        } catch {
            print(error)
        }
    }
    func selectBySql2() {
        let db = Database(at: dbPath)
        do {
            // 1、准备sql语句，由于会自动拼接SELECT,需要将手写的SELECT去掉
            // 2、where条件语句也一起拼接在sql语句中
            let sql = "SELECT Score_Table.identifier, Score_Table.stuId, Score_Table.score FROM Score_Table where Score_Table.stuId=345".replacingOccurrences(of: "SELECT", with: "")
            let statementSelect = StatementSelect().select(Column(named: sql))
            // 执行查询
            let handle = try db.getHandle()
            try handle.prepare(statementSelect)
            // 获取查询结果
            while try handle.step() {
                let val0 = handle.value(atIndex: 0).intValue
                let val1 = handle.value(atIndex: 1).intValue
                let val2 = handle.value(atIndex: 2).doubleValue
                print("selectBySql2: identifier:\(val0) stuId:\(val1) score:\(val2)")
            }
        } catch {
            print(error)
        }
    }
    func selectBySql3() {
        let db = Database(at: dbPath)
        do {
            // 1、准备sql语句，由于会自动拼接SELECT,需要将手写的SELECT去掉
            // 2、where条件语句由WCDB的方式设置
            let sql = "SELECT Score_Table.identifier, Score_Table.stuId, Score_Table.score FROM Score_Table".replacingOccurrences(of: "SELECT", with: "")
            let statementSelect = StatementSelect().select(Column(named: sql)).where(ScoreDBModel.Properties.stuId==345)
            // 执行查询
            let handle = try db.getHandle()
            try handle.prepare(statementSelect)
            // 获取查询结果
            while try handle.step() {
                let val0 = handle.value(atIndex: 0).intValue
                let val1 = handle.value(atIndex: 1).intValue
                let val2 = handle.value(atIndex: 2).doubleValue
                print("selectBySql3 identifier:\(val0) stuId:\(val1) score:\(val2)")
            }
        } catch {
            print(error)
        }
    }
    // MARK: - 连表查询
    func selectJoinOn1() {
        let db = Database(at: dbPath)
        do {
            // 1、准备sql语句，由于会自动拼接SELECT,需要将手写的SELECT去掉
            // 2、多表查询使用JOIN、on
            let sqlStr =
"""
SELECT Score_Table.score, Score_Table.identifier, Students.name, Students.studentId FROM Score_Table
            JOIN Students on Score_Table.stuId=Students.studentId
""".replacingOccurrences(of: "SELECT", with: "")
            let statementSelect = StatementSelect().select(Column(named: sqlStr))
            // 执行查询
            let handle = try db.getHandle()
            try handle.prepare(statementSelect)
            // 获取查询结果
            while try handle.step() {
                let val0 = handle.value(atIndex: 0).doubleValue
                let val1 = handle.value(atIndex: 1).intValue
                let val2 = handle.value(atIndex: 2).stringValue
                let val3 = handle.value(atIndex: 3).intValue
                print("selectJoinOn1 score:\(val0) identifier:\(val1) name:\(val2) studentId:\(val3)")
            }
        } catch {
            print(error)
        }
    }
    func selectJoinOn2() {
        let db = Database(at: dbPath)
        do {
            // 1、准备sql语句，由于会自动拼接SELECT,需要将手写的SELECT去掉
            // 2、多表查询使用JOIN、on
            // 3、查询条件可以写在sql语句里
            let sqlStr =
"""
SELECT Score_Table.score, Score_Table.identifier, Students.name, Students.studentId FROM Score_Table
            JOIN Students on Score_Table.stuId=Students.studentId
WHERE Score_Table.stuId=345
""".replacingOccurrences(of: "SELECT", with: "")
            let statementSelect = StatementSelect().select(Column(named: sqlStr))
            // 执行查询
            let handle = try db.getHandle()
            try handle.prepare(statementSelect)
            // 获取查询结果
            while try handle.step() {
                let val0 = handle.value(atIndex: 0).doubleValue
                let val1 = handle.value(atIndex: 1).intValue
                let val2 = handle.value(atIndex: 2).stringValue
                let val3 = handle.value(atIndex: 3).intValue
                print("selectJoinOn2 score:\(val0) identifier:\(val1) name:\(val2) studentId:\(val3)")
            }
        } catch {
            print(error)
        }
    }
    func selectJoinOn3() {
        let db = Database(at: dbPath)
        do {
            // 1、准备sql语句，由于会自动拼接SELECT,需要将手写的SELECT去掉
            // 2、多表查询使用JOIN、on
            // 3、查询条件使用wcdb的方式设置
            let sqlStr =
"""
Score_Table.score, Score_Table.identifier, Students.name, Students.studentId FROM Score_Table
            JOIN Students on Score_Table.stuId=Students.studentId
""".replacingOccurrences(of: "SELECT", with: "")
            let statementSelect = StatementSelect()
            statementSelect.select(Column(named: sqlStr)).where(ScoreDBModel.Properties.stuId==345)
            // 执行查询
            let handle = try db.getHandle()
            try handle.prepare(statementSelect)
            // 获取查询结果
            while try handle.step() {
                let val0 = handle.value(atIndex: 0).doubleValue
                let val1 = handle.value(atIndex: 1).intValue
                let val2 = handle.value(atIndex: 2).stringValue
                let val3 = handle.value(atIndex: 3).intValue
                print("selectJoinOn3 score:\(val0) identifier:\(val1) name:\(val2) studentId:\(val3)")
            }
        } catch {
            print(error)
        }
    }
    func selectJoinOn4() {
        let db = Database(at: dbPath)
        do {
            // 先查询一张表
            let scoreList: [ScoreDBModel] = try db.getObjects(on: ScoreDBModel.Properties.all, fromTable: ScoreDBModel.tableName)
            // 将查询结果作为条件查询第二张表
            let stuIds: [Int] = scoreList.map { $0.stuId ?? 0 }
            let students: [StudentDBModel] = try db.getObjects(on: StudentDBModel.Properties.all, fromTable: StudentDBModel.tableName, where: StudentDBModel.Properties.studentId.in(stuIds))
            // 将两张表的查询结果根据业务关系关联在一起
            var studentsDict: [Int: StudentDBModel] = [:]
            for stu in students {
                studentsDict[stu.studentId ?? 0] = stu
            }
            var unionList: [(ScoreDBModel, StudentDBModel)] = []
            for score in scoreList {
                if let score_stu = studentsDict[score.stuId ?? 0] {
                    unionList.append((score, score_stu))
                }
            }
            // 使用数据
            for item in unionList {
                let score = item.0
                let score_stu = item.1
                print("selectJoinOn4 score:\(score.score ?? 0) identifier:\(score.identifier ?? 0) name:\(score_stu.name ?? "") studentId:\(score_stu.studentId ?? 0)")
            }
        } catch {
            print(error)
        }
    }
    func selectJoinOn5() {
        let db = Database(at: dbPath)
        do {
            // 先查询一张表
            let scoreList: [ScoreDBModel] = try db.getObjects(on: ScoreDBModel.Properties.all, fromTable: ScoreDBModel.tableName, where: ScoreDBModel.Properties.stuId==345)
            // 将查询结果作为条件查询第二张表
            let stuIds: [Int] = scoreList.map { $0.stuId ?? 0 }
            let students: [StudentDBModel] = try db.getObjects(on: StudentDBModel.Properties.all, fromTable: StudentDBModel.tableName, where: StudentDBModel.Properties.studentId.in(stuIds))
            // 将两张表的查询结果根据业务关系关联在一起
            var studentsDict: [Int: StudentDBModel] = [:]
            for stu in students {
                studentsDict[stu.studentId ?? 0] = stu
            }
            var unionList: [(ScoreDBModel, StudentDBModel)] = []
            for score in scoreList {
                if let score_stu = studentsDict[score.stuId ?? 0] {
                    unionList.append((score, score_stu))
                }
            }
            // 使用数据
            for item in unionList {
                let score = item.0
                let score_stu = item.1
                print("selectJoinOn5 score:\(score.score ?? 0) identifier:\(score.identifier ?? 0) name:\(score_stu.name ?? "") studentId:\(score_stu.studentId ?? 0)")
            }
        } catch {
            print(error)
        }
    }
}
