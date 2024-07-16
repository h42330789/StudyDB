//
//  PathTool.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/16/24.
//

import Foundation

class PathTool {
    public class var homeDir: String{
        return NSHomeDirectory()
    }
    
    public class var temporaryDir: String {
        return NSTemporaryDirectory()
    }
    
    public class var documentsDir: String {
        return userDomainOf(pathEnum: .documentDirectory)
    }
    
    public class var libraryDir: String {
        return userDomainOf(pathEnum: .libraryDirectory)
    }
    
    public class var cacheDir: String {
        return userDomainOf(pathEnum: .cachesDirectory)
    }
    
    private class func userDomainOf(pathEnum: FileManager.SearchPathDirectory) -> String {
        return NSSearchPathForDirectoriesInDomains(pathEnum, .userDomainMask, true)[0]
    }
    
}
extension String {
    func appendPath(_ path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
}
