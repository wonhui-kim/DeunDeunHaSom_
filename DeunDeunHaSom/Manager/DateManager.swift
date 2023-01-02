//
//  DateManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//
import Foundation
import UIKit

class DateManager {
    
    static let shared = DateManager()
    
    let dateFormatter = DateFormatter()
    var userDate = Date()
    
    func fetchDate() -> String {
        dateFormatter.dateFormat = "MM. dd"
        
        return dateFormatter.string(from: userDate)
    }
    
    func fetchDayEn() -> String {
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "en")
        
        return dateFormatter.string(from: userDate)
    }
    
    func fetchTodayEn() -> String {
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "en")
            
            return dateFormatter.string(from: Date())
        }
    
    func fetchDayKor() -> String {
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: userDate)
    }
    
    func fetchTodayKor() -> String {
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: Date())
    }
    
    func dayAfterTomorrowKor() -> String {
        var dayAfterTomorrow = Date()
        if let addDay = Calendar.current.date(byAdding: .day, value: 2, to: dayAfterTomorrow) {
            dayAfterTomorrow = addDay
        }
        
        return dateFormatter.string(from: dayAfterTomorrow)
    }
    
    func addDate() {
        if let addDate = Calendar.current.date(byAdding: .day, value: 1, to: userDate) {
            userDate = addDate
        }
    }
    
    func subtractDate() {
        if let subtractDate = Calendar.current.date(byAdding: .day, value: -1, to: userDate) {
            userDate = subtractDate
        }
    }
}
