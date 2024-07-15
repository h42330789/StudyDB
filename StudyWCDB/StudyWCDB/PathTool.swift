//
//  PathTool.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/16/24.
//

import Foundation

class PathTool {
    static var documentsDirectory: URL {
        let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docUrl
    }
}
