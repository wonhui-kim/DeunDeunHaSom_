//
//  DateManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//

import Foundation

let dateFormatter = DateFormatter()

func fetchYearAndMonth() -> String {
    dateFormatter.dateFormat = "yyyy년 MM월"
    
    return dateFormatter.string(from: Date())
}

func fetchDate() -> String {
    dateFormatter.dateFormat = "dd"
    
    return dateFormatter.string(from: Date())
}

func fetchDay() -> String {
    dateFormatter.dateFormat = "(E요일)"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    
    return dateFormatter.string(from: Date())
}
