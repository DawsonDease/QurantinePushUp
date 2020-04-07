//
//  Entry.swift
//  QurantinePushUp
//
//  Created by Dawson on 2020-03-31.
//  Copyright © 2020 Dawson. All rights reserved.
//

import Foundation
import UIKit
import os.log

struct PropertyKey{
    static let date = "date"
    static let pushups = "pushups"
}



class Entry: NSObject, NSCoding{
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("entries")
    static let ArchiveURLDaily = DocumentsDirectory.appendingPathComponent("daily")
    public var date : String
    public var pushups : Int
    
    init(date: String, pushUps: Int) {
        self.date = date
        self.pushups = pushUps
    }
    
    //MARK: NSCoding
    func encode(with acoder: NSCoder) {
        acoder.encode(date, forKey: PropertyKey.date)
        acoder.encode(String(pushups), forKey: PropertyKey.pushups)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
       guard let newDate = aDecoder.decodeObject(forKey: PropertyKey.date) as? String else{
           os_log("Missing Date", log: OSLog.default, type: .debug)
           return nil
       }
       
       guard let newPushups = aDecoder.decodeObject(forKey: PropertyKey.pushups) as? String else {
           os_log("Missing pushups", log: OSLog.default, type: .debug)
           return nil
       }
       
        self.init(date: newDate, pushUps: Int(newPushups) ?? 0 )
    }

}
