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
    var date:Date!
    
    init(stat:String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let restoredDate = formatter.date(from: stat)
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let month = (cal as NSCalendar).components(NSCalendar.Unit.month, from: restoredDate!)
        let year = (cal as NSCalendar).components(NSCalendar.Unit.year, from: restoredDate!)

        self.month = month.month
        self.year = year.year
        self.date = restoredDate
    }
    
    func isCurrentMonthYear() -> Bool {
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let completedMonth = (cal as NSCalendar).components(NSCalendar.Unit.month, from: self.date)
        let completedYear = (cal as NSCalendar).components(NSCalendar.Unit.year, from: self.date)
        
        let now = Date()
        let nowMonth = (cal as NSCalendar).components(NSCalendar.Unit.month, from: now)
        let nowYear = (cal as NSCalendar).components(NSCalendar.Unit.year, from: now)
        
        // need to find out if the selected month is the current month
        return (completedYear.year == nowYear.year && completedMonth.month == nowMonth.month)
                    
    }
    
    
    var daysInMonth : Int {
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        
        // need to find out if the selected month is the current month
        if (isCurrentMonthYear()) {

            let now = Date()
            let today = (cal as NSCalendar).components(NSCalendar.Unit.day, from: now)

            let totalPossibleDaysInMonthThusFar = today.day
            return totalPossibleDaysInMonthThusFar!
            
        } else {
            
            let days = (cal as NSCalendar).range(of: .day, in: .month, for: date)
            return days.length
        }
    
    }
    
    var monthName : String {
        
        let formatter = DateFormatter()
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
