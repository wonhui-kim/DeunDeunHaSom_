//
//  DateManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//
import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    //토요일날짜를 넣으면 다음 금요일 날짜와 함께 반환 (startdate와 enddate 반환)
    func startEndDate() -> [String:String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let startDate = startDate()
        
        let parameter = startDate.split(separator: ".").map {
            Int(String($0))
        }
        
        let dateComponents = DateComponents(year: parameter[0], month: parameter[1], day: parameter[2])
        let tempDate = Calendar.current.date(from: dateComponents)!
        let startDateString = dateFormatter.string(from: tempDate)
        
        let add6Days = Calendar.current.date(byAdding: .day, value: 6, to: tempDate)!
        let endDateString = dateFormatter.string(from: add6Days)
        
        //["STARTDATE": "20230527", "ENDDATE": "20230602"]
        return ["STARTDATE":startDateString, "ENDDATE":endDateString]
    }
    
    //오늘이 토요일이면 -> 토요일날짜, 오늘이 평일이면 -> 지난 토요일 날짜
    func startDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyy.MM.dd E"
        
        let today = Date()
        
        //날짜를 "yyyy.MM.dd E" 형식으로 변경
        let dateString = dateFormatter.string(from: today).split(separator: " ").map {
            String($0)
        }
        
        if dateString[1] == "토" {
            return dateString[0]
        } else {
            for i in stride(from: -1, through: -6, by: -1) {
                let subDays = Calendar.current.date(byAdding: .day, value: i, to: today)!
                let tempDate = dateFormatter.string(from: subDays).split(separator: " ").map {
                    String($0)
                }
                
                if tempDate[1] == "토" {
                    return tempDate[0]
                }
            }
        }
        
        return "no result"
    }
    
    //이번주 월,화,수,목,금 날짜(뒷자리)만 반환 -> 날짜 버튼 title 나타내기 위한 용도
    func weekDate() -> [String] {
        let startDateString = startDate() //시작 날짜 받아옴
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd" //뒤에 날짜만 필요함
        
        //2023.05.27(startDate) 를 2023 05 27로 분리
        let parameter = startDateString.split(separator: ".").map {
            Int(String($0))
        }
        //시작일(날짜)를 Date 타입으로 변환
        let dateComponents = DateComponents(year: parameter[0], month: parameter[1], day: parameter[2])
        let startDate = Calendar.current.date(from: dateComponents)!
        
        var dateList = [String]()
        for i in stride(from: 2, through: 6, by: 1) { //월(+2)~금(+6)
            let addDay = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
            dateList.append(dateFormatter.string(from: addDay))
        }
        
        return dateList
    }
    
    func today() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        
        let today = dateFormatter.string(from: Date())

        return today
    }
    
    //월이면 0, ... 금이면 4 인덱스 반환
    func todayIndex() -> Int {
        
        let todayString = today()
        
        switch todayString { //일, 월요일 -> 월요일 식단, 금, 토요일 -> 금요일 식단
        case "일", "월":
            return 0
        case "화":
            return 1
        case "수":
            return 2
        case "목":
            return 3
        default: //금, 토
            return 4
        }
    }
}

