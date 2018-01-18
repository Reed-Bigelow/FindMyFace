//
//  Int+Extensions.swift
//  FindMyFace
//
//  Created by Developer on 11/7/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import Foundation

extension Int {
    
    func ordinalString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? ""
    }
    
    func hourTimestamp() -> String {
        var timeModifier = "hours"
        
        if self == 1 {
            timeModifier = "hour"
        }
        
        return "\(self) \(timeModifier) ago"
    }
    
    func minuteTimestamp() -> String {
        var timeModifier = "minutes"
        
        if self == 1 {
            timeModifier = "minute"
        }
        
        return "\(self) \(timeModifier) ago"
    }
    
    func secondTimestamp() -> String {
        var timeModifier = "seconds"
        
        if self == 1 {
            timeModifier = "second"
        }
        
        return "\(self) \(timeModifier) ago"
    }
}
