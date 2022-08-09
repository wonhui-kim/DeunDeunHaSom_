//
//  DateManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//
import Foundation
import UIKit

class DateManager {
    
    let dateFormatter = DateFormatter()
    var userDate = Date()
    
    func fetchYear() -> String {
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: userDate)
    }
    
    func fetchDate() -> String {
        dateFormatter.dateFormat = "MM. dd"
        
        return dateFormatter.string(from: userDate)
    }
    
    func fetchDay() -> String {
        dateFormatter.dateFormat = "(E요일)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: userDate)
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

