//
//  Date.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

extension Date {
    
    func utcString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: self)
    }
    
    func dayOrdinal() -> String {
        guard let ordinal = Calendar(identifier: .gregorian).dateComponents([.day, .month], from: self).day?.ordinalString() else {
            return ""
        }
        
        return ordinal
    }
    
    func monthOrdinal() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    func monthDayTimestamp() -> String {
        let ordinal = self.dayOrdinal()
        let month = self.monthOrdinal()
        return "\(month) \(ordinal)"
    }
    
    func timestamp() -> String {
        let differenceComponets = Calendar(identifier: .gregorian).dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        
        guard let day = differenceComponets.day, let hour = differenceComponets.hour, let minute = differenceComponets.minute, let second = differenceComponets.second else {
            return ""
        }
        
        if day > 0 {
            return self.monthDayTimestamp()
        } else if hour > 0 {
            return hour.hourTimestamp()
        } else if minute > 0 {
            return minute.minuteTimestamp()
        } else {
            return second.secondTimestamp()
        }
    }
}
