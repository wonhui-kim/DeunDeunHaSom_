//
//  CrawlManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/09.
//

import SwiftSoup
import Alamofire

struct CrawlManager {
    
    static func crawlStaffMeal() {
        let urlStr = "https://www.dongduk.ac.kr/kor/life/cafeteria.do"
        //let classPath = "#ulWeekDtInfo > li:nth-child(1) > dl > dd:nth-child(14)"
        
        
        AF.request(urlStr).responseString { (response) in
            guard let html = response.value else {
                return
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let elements: Elements = try doc.select("dl > dd")
                for element in elements {
                    print(try element.text())
                }
            } catch {
                print("crawl error")
            }
        }
    }
}
