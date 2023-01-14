//
//  Exp.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import Foundation

extension Date {
    static var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar
    }()
    
    var startOfWeek: Date {
        
        let components = Date.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        guard let firstDat = Date.calendar.date(from: components) else { return self }
        return Date.calendar.date(byAdding: .day, value: 0, to: firstDat) ?? self
    }
    
    func agoForward(to days: Int) -> Date {
        return Date.calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func stripTime() -> Date {
        let components = Date.calendar.dateComponents([.year, .month, .day], from: self)
        return Date.calendar.date(from: components) ?? self
    }
}
