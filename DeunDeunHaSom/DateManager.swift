//
//  DateManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//
import Foundation

let dateFormatter = DateFormatter()

func fetchYear() -> String {
    dateFormatter.dateFormat = "yyyy"
    
    return dateFormatter.string(from: Date())
}

func fetchDate() -> String {
    dateFormatter.dateFormat = "MM. dd"
    
    return dateFormatter.string(from: Date())
}

func fetchDay() -> String {
    dateFormatter.dateFormat = "(E요일)"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    
    return dateFormatter.string(from: Date())
}
