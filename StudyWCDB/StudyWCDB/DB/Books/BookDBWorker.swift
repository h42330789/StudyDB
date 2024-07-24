//
//  BookDBWorker.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/24/24.
//

import Foundation
import WCDBSwift

class BookDBWorker {
    let dbPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/test.db"
    var database: Database? = nil
    
    // MARK: 初始化数据库和表
    init() {
        // 初始化数据库对象
        database = Database(at: dbPath)
        do {
            // 要初始化建表（没有创建过该表就建表，已经建过表了有字段变更就做响应处理）
            try database?.create(table: "books", of: BookDBModel.self)
        } catch {
            print(error)
        }
    }
    
    // MARK: 插入数据
    func addBooks(books: [BookDBModel]) -> Bool {
        do {
            try database?.insert(books, intoTable: "books")
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    // MARK: 查询数据
    func selectBooks() -> [BookDBModel]? {
        do {
            let list: [BookDBModel]? = try database?.getObjects(on: BookDBModel.Properties.all, fromTable: "books")
            return list
        } catch {
            print(error)
            return nil
        }
    }
    func selectBook(name: String) -> BookDBModel? {
        do {
            let book: BookDBModel? = try database?.getObject(on: BookDBModel.Properties.all, fromTable: "books", where: BookDBModel.Properties.name == name)
            return book
        } catch {
            print(error)
            return nil
        }
    }
    
}
