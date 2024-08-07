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
        testStu1()
        testStu2()
//        testWebSite()
//        testMessage()
//        testBook()
//        testPeople()
//        testMember()
        
        
    }
    func testMember() {
        let datas = [
            ["user": [
                "uid": 8,
                "name": "网王",
                "pic": "http://www.baidu.com",
                "gender": 1,
                "friendRelation": [
                    "isFriend": true,
                    "remarkName": "汪汪"
                ],
                "userOnOrOffline": [
                    "uid": 8,
                    "isOnline": true,
                    "onlineOrOfflineTime": 2341234,
                    "isShowOnLineStatus": false
                ],
            ],
             "groupID": 1000,
             "type": 2,
            ]
        ]
        let models = datas.map {
            var model = GroupMemberInfo()
            if let userDict = $0["user"] as? [String: Any] {
                if let val = userDict["uid"] as? Int {
                    model.user.uid = Int64(val)
                }
                if let val = userDict["name"] as? String {
                    model.user.name = val
                }
                if let val = userDict["pic"] as? String {
                    model.user.pic = val
                }
                if let val = userDict["gender"] as? Int,
                   let typeVal = MemberGender(rawValue: val) {
                    model.user.gender = typeVal
                }
                var userDict = $0["user"] as? [String: Any] ?? [:]
                if let relationDict = userDict["friendRelation"] as? [String: Any] {
                    if let val = relationDict["isFriend"] as? Bool {
                        model.user.friendRelation.isFriend = val
                    }
                    if let val = relationDict["remarkName"] as? String {
                        model.user.friendRelation.remarkName = val
                    }
                }
                if let onlineDict = userDict["userOnOrOffline"] as? [String: Any] {
                    if let val = onlineDict["uid"] as? Int {
                        model.user.userOnOrOffline.uid = Int64(val)
                    }
                    if let val = onlineDict["isOnline"] as? Bool {
                        model.user.userOnOrOffline.isOnline = val
                    }
                    if let val = onlineDict["onlineOrOfflineTime"] as? Int {
                        model.user.userOnOrOffline.onlineOrOfflineTime = Int64(val)
                    }
                    if let val = onlineDict["isShowOnLineStatus"] as? Bool {
                        model.user.userOnOrOffline.isShowOnLineStatus = val
                    }
                }
            }
            if let val = $0["groupID"] as? Int {
                model.groupID = Int64(val)
            }
            if let val = $0["type"] as? Int,
               let typeVal = MemberType(rawValue: val) {
                model.type =  typeVal
            }
            
            return model
        }
        let worker = MemberDBWorker()
//        worker.deleteAll()
        let result = worker.addMembers(list: models)
        let searchList = worker.allMembers()
        if var upModel = searchList?.first {
            upModel.user.friendRelation.remarkName = "马良\(Int.random(in: 0...9))"
            
        }
        let updateResult = worker.update(infos: searchList!)
        let searchList2 = worker.searchMember(remarkName: "马良")
        print(searchList)
    }
    func testPeople() {
        let worker = PeopleDBWorker()
        // 设置数据
        let datas = [
            ["name": "李白",
             "age": 1000,
             "height": 184.0,
             "isMarried": false,
             "birthDate": Date(),
             "loveBooks": ["史记","论语"],
             "gender": 0,
             "loveSport": "basketball",
             "pet": ["name": "xiaowang","age": 5, "type": 1],
             "extra": ["fater":"who","pic":"http://www.baidu.com"]
            ]
        ]
        let models = datas.map {
            let model = PeopleModel()
            model.name = $0["name"] as? String
            model.age = $0["age"] as? Int
            model.height = $0["height"] as? Double
            model.isMarried = $0["isMarried"] as? Bool
            model.birthDate = $0["birthDate"] as? Date
            model.loveBooks = $0["loveBooks"] as? [String]
            if let val = $0["gender"] as? Int {
                model.gender = Gender(rawValue:  val)
            }
            if let val = $0["loveSport"] as? String {
                model.loveSport = SportType(rawValue:  val)
            }
            if let val = $0["pet"] as? [String: Any] {
                if let name = val["name"] as? String,
                   let age = val["age"] as? Int,
                   let type = val["type"] as? Int,
                   let petType = Pet.PetType(rawValue: type) {
                    model.pet = Pet(name: name, age: age, type: petType)
                }
            }
            model.extra = $0["extra"] as? [String: Any]
            return model
        }
        let result = worker.addPeoples(list: models)
        let resultList = worker.selectPeoples()
        print(result, resultList)
    }
    
    
    func testBook() {
        let worker = BookDBWorker()
        // 设置数据
        let datas = [
            ["name": "大学高数",
             "picUrl": "https://bkimg.cdn.bcebos.com/pic/9922720e0cf3d7ca41810db7f21fbe096a63a9ff",
             "desc": "高等数学是初等数学与大学阶段的高等数学的过渡",
             "price": 99],
            
            ["name": "穷爸爸富爸爸",
             "picUrl": "https://bkimg.cdn.bcebos.com/pic/e4dde71190ef76c61eca1e0f9f16fdfaaf5167fe",
             "desc": "该书讲述了清崎有两个爸爸：“穷爸爸”是他的亲生父亲，一个高学历的教育官员",
             "price": 100],
        ]
        let models = datas.map {
            let model = BookDBModel()
            model.name = $0["name"] as? String
            model.picUrl = $0["picUrl"] as? String
            model.desc = $0["desc"] as? String
            return model
        }
        let result = worker.addBooks(books: models)
        let books = worker.selectBooks()
        let book = worker.selectBook(name: "穷爸爸富爸爸")
        print(result, books, book)
    }
    func testStu1() {
        testStuAddData()
        let worker = StudentDBWorker()
        worker.selectBySql1()
        worker.selectBySql2()
        worker.selectBySql3()
    }
    func testStuAddData() {
        let worker = StudentDBWorker()
        if let count = worker.getStuCount(), count == 0 {
            // 没有数据，更新数据
            let datas = [
                ["id": 21434, "name": "梅梅", "age": 8],
                ["id": 345, "name": "集美", "age": 19],
            ]
            let stus = datas.map {
                let stu = StudentDBModel()
                stu.studentId = $0["id"] as? Int
                stu.name = $0["name"] as? String
                stu.age = $0["age"] as? Int
                return stu
            }
    
    
            let result = worker.addStus(stus: stus)
            print(result)
            
        let datas2: [[String: Any]] = [
                ["studentId": 21434, "score": 80.0,],
                ["studentId": 345, "score": 65.0],
            ]
            let scores = datas2.map {
                let score = ScoreDBModel()
                score.stuId = $0["studentId"] as? Int
                score.score = $0["score"] as? Double
                return score
            }
            let result2 = worker.addScore(scores: scores)
            print(result2)
        }
    }
    func testStu2() {
        let worker = StudentDBWorker()
        testStuAddData()
        // 查询数据
        worker.selectJoinOn1()
        worker.selectJoinOn2()
        worker.selectJoinOn3()
        worker.selectJoinOn4()
        worker.selectJoinOn5()
        
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

