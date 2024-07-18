//
//  ViewController.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/15/24.
//

import UIKit
import WCDBSwift

// https://juejin.cn/post/6844904117446377485
// https://www.runoob.com/sql/sql-between.html
//https://github.com/Tencent/wcdb/wiki/Swift-%e7%9b%91%e6%8e%a7%e4%b8%8e%e9%94%99%e8%af%af%e5%a4%84%e7%90%86

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        testStu()
//        testWebSite()
        testMessage()
        
        
    }
    
    func testStu() {
        let worker = StudentDBWorker()
        if let count = worker.getStuCount(), count == 0 {
            // 没有数据，更新数据
            let datas = [
                ["id": 21434, "name": "梅梅", "age": 8],
                ["id": 345, "name": "集美", "age": 19],
            ]
            let stus = datas.map {
                let stu = StudentDBModel()
                stu.stuId = $0["id"] as? Int
                stu.name = $0["name"] as? String
                stu.age = $0["age"] as? Int
                return stu
            }
    
    
            let result = worker.addStus(stus: stus)
            print(result)
            
            let datas2 = [
                ["studentId": 21434, "name": "梅梅", "score": 80.0],
                ["studentId": 345, "name": "梅梅", "score": 65.0],
            ]
            let scores = datas2.map {
                let score = ScoreDBModel()
                score.studentId = $0["studentId"] as? Int
                score.score = $0["score"] as? Double
                return score
            }
            let result2 = worker.addScore(scores: scores)
            print(result2)
        }
        // 查询数据
        worker.getScoreAndStus()
        
    }
    
    func testWebSite() {
        let worker = WebSiteDBWorker()
        if let count = worker.getWebSitesCount(), count == 0 {
            // 没有数据，更新数据
            let datas = [
                ["name": "Google", "url": "https://www.google.cm/", "alexa": 1, "country": "USA"],
                ["name": "淘宝", "url": "https://www.taobao.com/", "alexa": 13, "country": "CN"],
                ["name": "菜鸟教程", "url": "http://www.runoob.com/", "alexa": 5000, "country": "USA"],
                ["name": "微博", "url": "http://weibo.com/", "alexa": 20, "country": "CN"],
                ["name": "Facebook ", "url": "https://www.facebook.com/", "alexa": 3, "country": "USA"],
                ["name": "stackoverflow", "url": "http://stackoverflow.com/", "alexa": 0, "country": "IND"],
                ["name": "Github", "url": "http://Github.com/", "alexa": 20, "country": "USA"],
            ]
            let webs = datas.map {
                let web = WebSiteDBModel()
                web.name = $0["name"] as? String
                web.url = $0["url"] as? String
                web.alexa = $0["alexa"] as? Int
                web.country = $0["country"] as? String
                web.marks = ["a", "b"]
                web.extra = ["name": "a", "age": "10"]
                return web
            }
    
    
            let result = worker.addWebSites(sites: webs)
            print(result)
        }
        // 查询数据
        let list = worker.getWebSites()
        let ob = worker.getWebSite(name: "Google")
        let count = worker.getWebSitesCount()
        let countryCount1 = worker.getWebSitesCountryCount(isDistinct: true)
        let countryCount2 = worker.getWebSitesCountryCount(isDistinct: false)
        let alexTotal = worker.getWebSitesAlexTotal()
        let avg = worker.getWebSiteAlexAvg()
        let max = worker.getWebSiteAlexMax()
        let min = worker.getWebSiteAlexMin()
        let sum = worker.getWebSiteAlexSum()
        let list2 = worker.getWebsitesNameLike(likeExp: "%le")
        let list3 = worker.getWebsitesNameLike(likeExp: "g%")
        let list4 = worker.getWebsitesNameLike(likeExp: "%goo%")
        let list5 = worker.getWebsitesNameREGEXP(regExp: "%goo%")
        print(list, ob, count, countryCount1, countryCount2, avg, max, min, sum)
        print(list2, list3, list4, list5)
    }

    func testMessage() {
        let worker = MessageDBWorker()
        // 复杂类型，需要有个专门的类转一遍
        if let count = worker.getMsgCount2(), count == 0 {
            // 没有数据，更新数据
            let datas = Array.init(repeating: 0, count: 10)
            let msgs = datas.map {_ in
                let messageType = MessageType(rawValue: Int32.random(in: 0..<3))
                let msg = MessageModel.model(messageType: messageType)
                if let msgVal = msg as? TextMessageModel {
                    
                } else if let msgVal = msg as? VideoMessageModel {
                    msgVal.fileSize = 10
                    msgVal.fileName = "fileName-video"
                    msgVal.url = "videoUrl"
                } else if let msgVal = msg as? ImageMessageModel {
                    msgVal.fileSize = 10
                    msgVal.fileName = "fileName-iamge"
                    msgVal.url = "imageUrl"
                    msgVal.width = 100
                    msgVal.height = 200
                    msgVal.thumbFileName = "thumbFile"
                    msgVal.thumbUrl = "image-thumUrl"
                }
                msg.msgId = Int64.random(in: 1000..<10000)
                msg.flag = Int64.random(in: 1000..<10000)
                msg.chatType = ChatType(rawValue: Int32.random(in: 0..<2))
                msg.messageType = messageType
                msg.content = "msg hello \(Int64.random(in: 1000..<10000))"
                let refMsg = RefMessage()
                refMsg.msgId = Int64.random(in: 1000..<10000)
                refMsg.content = "refMsg content world \(Int64.random(in: 1..<10))"
                refMsg.type = MessageType(rawValue: Int32.random(in: 1...6))
                refMsg.uid = Int64.random(in: 1...6)
                refMsg.nickname = "refMsg nick name \(Int64.random(in: 1..<10))"
                msg.refMsg = refMsg
                return msg
            }
    
    
            let result = worker.addMessages(msgs: msgs)
            print(result)
        }
        // 查询数据
        let list = worker.getMessages3()
        print(list)
    }
}

