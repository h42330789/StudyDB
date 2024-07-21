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
                print("\(info.costInNanoseconds/1000000) millseconds \(info.costInNanoseconds%1000000) nanoseconds to execute sql \(sql)");
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
    
    // MARK: - 连表查询
    func getScoreAndStus() {
        let db = Database(at: dbPath)
        do {
            // 查询表中的所有字典
            // 没有on就是全量字段插入
//            let multiSelect = try db.prepareMultiSelect(
//                on:
//                    ScoreDBModel.Properties.score.in(table: ScoreDBModel.tableName),
//                ScoreDBModel.Properties.identifier.in(table: ScoreDBModel.tableName),
//                    StudentDBModel.Properties.name.in(table: StudentDBModel.tableName),
//                StudentDBModel.Properties.stuId.in(table: StudentDBModel.tableName),
//                fromTables: [ScoreDBModel.tableName, StudentDBModel.tableName]
//            ).where(ScoreDBModel.Properties.studentId.in(ScoreDBModel.tableName) == StudentDBModel.Properties.stuId.in(StudentDBModel.tableName))
//            
//            while let multiObject = try multiSelect.nextMultiObject() {
//                let score = multiObject[ScoreDBModel.tableName] as? ScoreDBModel
//                let stu = multiObject[StudentDBModel.tableName] as? StudentDBModel
//                print(score, stu)
//            }
            // 联合查询
//            let query = """
//            SELECT ScoreDBModel.score, ScoreDBModel.identifier
//            FROM User
//            JOIN StudentDBModel ON User.id = Order.userId;
//            """
//            
//            let result: [String] = try db.getr
//            print(result)

        } catch {
            print(error)
        }
    }
}
