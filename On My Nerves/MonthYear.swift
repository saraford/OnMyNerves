//
//  MonthYear.swift
//  On My Nerves
//
//  Created by Sara Ford on 9/4/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import Foundation


func ==(lhs: MonthYear, rhs: MonthYear) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
    
}

class MonthYear : Hashable, Equatable, CustomStringConvertible {

    var month:Int!
    var year:Int!
    var date:NSDate!
    
    init(date:NSDate) {
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let month = cal.components(NSCalendarUnit.Month, fromDate: date)
        let year = cal.components(NSCalendarUnit.Year, fromDate: date)

        self.month = month.month
        self.year = year.year
        self.date = date
    }
    
    func isCurrentMonthYear() -> Bool {
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let completedMonth = cal.components(NSCalendarUnit.Month, fromDate: self.date)
        let completedYear = cal.components(NSCalendarUnit.Year, fromDate: self.date)
        
        let now = NSDate()
        let nowMonth = cal.components(NSCalendarUnit.Month, fromDate: now)
        let nowYear = cal.components(NSCalendarUnit.Year, fromDate: now)
        
        // need to find out if the selected month is the current month
        return (completedYear.year == nowYear.year && completedMonth.month == nowMonth.month)
                    
    }
    
    
    var daysInMonth : Int {
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        // need to find out if the selected month is the current month
        if (isCurrentMonthYear()) {

            let now = NSDate()
            let today = cal.components(NSCalendarUnit.Day, fromDate: now)

            let totalPossibleDaysInMonthThusFar = today.day
            return totalPossibleDaysInMonthThusFar
            
        } else {
            
            let days = cal.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
            return days.length
        }
    
    }
    
    var monthName : String {
        
        let formatter = NSDateFormatter()
        return formatter.monthSymbols[month - 1] 
        
    }

    var hashValue : Int {
        get {
            return "\(self.month),\(self.year)".hashValue
        }
    }
    
    var description: String {
        
        get {
            
            return "\(self.month) \(self.year)"
            
        }
    }
    
}
