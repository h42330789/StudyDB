//
//  Member.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/25/24.
//

import Foundation
// 群成员
struct GroupMemberInfo {
  // 用户基本信息
  var user: UserInfo = UserInfo()
  // 群ID
  var groupID: Int64 = 0
  // 成员类型
  var type: MemberType = .ower
  init() {}
}

// 成员类型
enum MemberType {
  typealias RawValue = Int
  case ower // 群主
  case admin // 管理员
  case member // 成员
  case other(Int)

  init() {
    self = .ower
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .ower
    case 1: self = .admin
    case 2: self = .member
    default: self = .other(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .ower: return 0
    case .admin: return 1
    case .member: return 2
    case .other(let val): return val
    }
  }

}

/// 用户基本信息
struct UserInfo {
  // 用户ID
  var uid: Int64 = 0
  // 昵称
  var name: String = ""
  // 头像
  var pic: String = ""
  // 性别
  var gender: MemberGender = .secrecy
  // 好友关系
  var friendRelation: MemberRelation = MemberRelation()
  // 用户上下线
  var userOnOrOffline: UserOnOrOffLine = UserOnOrOffLine()
  
  init() {}
}

// 性别
enum MemberGender {
  typealias RawValue = Int
  case secrecy // 保密
  case male // 男
  case female // 女
  case other(Int)

  init() {
    self = .secrecy
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .secrecy
    case 1: self = .male
    case 2: self = .female
    default: self = .other(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .secrecy: return 0
    case .male: return 1
    case .female: return 2
    case .other(let val): return val
    }
  }

}

class MemberPet {
    var name: String = ""
    var age: Int = 0
    
    required init(from decoder: Decoder) throws {
           // 这里只是一个占位符，实际实现会在另一个文件中
           self.name = ""
           self.age = 0
       }
}
// 好友关系信息
struct MemberRelation {
  // 是否好友
  var isFriend: Bool = false
  // 好友备注名
  var remarkName: String = String()

  init() {}
}

// 用户在线情况
struct UserOnOrOffLine {
  // 用户ID
  var uid: Int64 = 0
  // 是否在线
  var isOnline: Bool = false
  // 上下线时间
  var onlineOrOfflineTime: Int64 = 0
  // 是否显示在线状态
  var isShowOnLineStatus: Bool = false
  init() {}
}
// MARK: -
extension GroupMemberInfo {
    // 业务数据存入数据库时使用
    var dbModel: GroupMemberDBModel {
        let dbInfo = GroupMemberDBModel()
        dbInfo.user = user
        dbInfo.groupID = groupID
        dbInfo.type = type
        return dbInfo
    }
    mutating func bizModel(dbModel: GroupMemberDBModel) -> GroupMemberInfo {
        if let val = dbModel.user {
            user = val
        }
        if let val = dbModel.groupID {
            groupID = val
        }
        if let val = dbModel.type {
            type = val
        }
        return self
    }
    static func bizModel(_ dbModel: GroupMemberDBModel) -> GroupMemberInfo {
        var val = GroupMemberInfo()
        return val.bizModel(dbModel: dbModel)
    }
}
extension GroupMemberDBModel {
    // 数据库数据库解析成业务数据使用
    var bizModel: GroupMemberInfo {
        return GroupMemberInfo.bizModel(self)
    }
    
}

