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

class MonthYear : Hashable, Equatable, Printable {

    var month:Int!
    var year:Int!
    var date:NSDate!
    
    init(stat:String) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let restoredDate = formatter.dateFromString(stat)
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let month = cal.components(NSCalendarUnit.CalendarUnitMonth, fromDate: restoredDate!)
        let year = cal.components(NSCalendarUnit.CalendarUnitYear, fromDate: restoredDate!)

        self.month = month.month
        self.year = year.year
        self.date = restoredDate
    }
    
    func isCurrentMonthYear() -> Bool {
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let completedDay = cal.components(NSCalendarUnit.CalendarUnitDay, fromDate: self.date)
        let completedMonth = cal.components(NSCalendarUnit.CalendarUnitMonth, fromDate: self.date)
        let completedYear = cal.components(NSCalendarUnit.CalendarUnitYear, fromDate: self.date)
        
        let now = NSDate()
        let nowDay = cal.components(NSCalendarUnit.CalendarUnitDay, fromDate: now)
        let nowMonth = cal.components(NSCalendarUnit.CalendarUnitMonth, fromDate: now)
        let nowYear = cal.components(NSCalendarUnit.CalendarUnitYear, fromDate: now)
        
        // need to find out if the selected month is the current month
        return (completedYear.year == nowYear.year && completedMonth.month == nowMonth.month)
                    
    }
    
    
    var daysInMonth : Int {
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        // need to find out if the selected month is the current month
        if (isCurrentMonthYear()) {

            var now = NSDate()
            let today = cal.components(NSCalendarUnit.CalendarUnitDay, fromDate: now)

            var totalPossibleDaysInMonthThusFar = today.day
            return totalPossibleDaysInMonthThusFar
            
        } else {
            
            let days = cal.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date)
            return days.length
        }
    
    }
    
    var monthName : String {
        
        let formatter = NSDateFormatter()
        return formatter.monthSymbols[month - 1] as! String
        
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
