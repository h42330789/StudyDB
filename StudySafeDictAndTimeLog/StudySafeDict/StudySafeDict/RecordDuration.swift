//
//  RecordDuration.swift
//  StudySafeDict
//
//  Created by MacBook Pro on 8/12/24.
//

import Foundation

extension Date {
    static var milliseconds_64: Int64 {
        // 将 Date 转换为时间戳（秒）
        let seconds = Date().timeIntervalSince1970
        // 将时间戳转换为毫秒数
        let milliseconds = Int64(seconds * 1000)
        return milliseconds
    }
}
extension Int64 {
    var distanceToNow: (Int64, Int64) {
        let now = Date.milliseconds_64
        let dis = now - self
        return (dis, now)
    }
}
class RecordDuration {
    // 记录打点的时间数据
    static var timeRecodDict: [String: [Int64]] = [:]
    enum RecordTimeType {
        case firstTime // 距离同一个tag第一次记录的时间
        case preTime // 距离同一个tag上一次记录的时间
    }
    
    /// 记录埋点时间
    /// - Parameters:
    ///   - tag: 埋点tag
    ///   - logFlag: 打印出的日志的前缀
    ///   - msg: 额外展示的消息，可以不用
    ///   - logType: 比较时间的方式，默认与同一个tag的上一次埋点比较，也可以与埋点的第一次比较
    static func log(tag: String?, logFlag: String = "===>>++>", msg: String? = nil,
                        logType: RecordTimeType = .preTime,
                        file: StaticString = #file,
                        function: StaticString = #function,
                        line: UInt = #line) {
        // 只有debug模式下才开启
#if DEBUG
        // 有tag就使用tag，没有tag就使用类名、方法名
        let tagStr = tag ?? "\(file)_\(function)_\(line)"
        var tagTimeList = timeRecodDict[tagStr] ?? []
        var duration: Int64 = 0
        if logType == .preTime {
            // 距离同一个Tag的上一次时间
            if let lastTime = tagTimeList.last {
                // 距离上一次的时间
                let(dis, now) = lastTime.distanceToNow
                tagTimeList.append(now)
                duration = dis
            } else {
                // 不存在上一次，则属于第一次
                tagTimeList.append(Date.milliseconds_64)
            }
        } else {
            // 距离同一个Tag的第一次时间
            if let firstTime = tagTimeList.first {
                // 距离上一次的时间
                let(dis, now) = firstTime.distanceToNow
                tagTimeList.append(now)
                duration = dis
            } else {
                // 不存在上一次，则属于第一次
                tagTimeList.append(Date.milliseconds_64)
            }
        }
        // 重新设置值
        timeRecodDict[tagStr] = tagTimeList
        if let msg = msg, msg.count > 0 {
            print("\(logFlag) \(tagStr) \(msg) dis:\(duration)")
        } else {
            print("\(logFlag) \(tagStr) dis:\(duration)")
        }
        
#endif
    }
}
