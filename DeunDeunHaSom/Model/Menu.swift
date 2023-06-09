//
//  Menu.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/05/27.
//

import Foundation

struct CafeteriaResponse: Codable {
    let callBackCode: String
    let msg: String
    let cafeteriaList: [Menu]
}

struct Menu: Codable {
    let startDate: String
    let content: String?
    let type: Int
    let endDate: String
    
    enum CodingKeys: String, CodingKey {
        case startDate = "STARTDATE"
        case content = "CONTENT"
        case type = "TYPE"
        case endDate = "ENDDATE"
    }
}

struct Restaurant {
    var staff: [String]
    var student: [String]
}

/* success
 {
     "callBackCode": "success",
     "msg": "성공적으로 처리되었습니다.",
     "cafeteriaList": [
         {
             "STARTDATE": "20230318",
             "CONTENT": null,
             "TYPE": 1,
             "ENDDATE": "20230324"
         },
        {
            "STARTDATE": "20230318",
            "CONTENT": null,
            "TYPE": 2,
            "ENDDATE": "20230324"
        }]
 }
 */

/* failure
 {
     "callBackCode": "fail",
     "msg": "처리중 에러가 발생하였습니다."
 }
 */
