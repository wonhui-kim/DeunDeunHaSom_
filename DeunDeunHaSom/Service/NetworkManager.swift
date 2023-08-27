//
//  NetworkManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/12.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidID
    case invalidData
    case invalidStatusCode
    case jsonConvertError
    case unknownError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func requestData(url: String, parameters: [String:String]) async throws -> [String] {
        
        guard let url = URL(string: url) else {
            throw APIError.invalidURL
        }
        
        let formDataString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = formDataString.data(using: .utf8)
        request.httpBody = requestBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.invalidStatusCode
        }
        
        let cafeteriaResponse = try JSONDecoder().decode(CafeteriaResponse.self, from: data)
        
        var results = [String]()
        
        cafeteriaResponse.cafeteriaList.forEach { menu in
            if (31...35).contains(menu.type) {
                guard let eachMenu = menu.content else {
                    results.append("오늘은 운영하지 않아요 🥲")
                    return
                }
                results.append(eachMenu)
            }
        }
        
        return results
    }
    
    func todayMenus(url: String, parameters: [String:String], completion: @escaping (Result<Restaurant, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let formDataString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = formDataString.data(using: .utf8)
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            //dataTask 에러임 -> 어떤 에러가 있는지 생각해보기 + response를 왜 안쓰는지, 각 파라미터가 뭔지
            if error != nil {
                completion(.failure(APIError.unknownError))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            do {
                let cafeteriaResponse = try JSONDecoder().decode(CafeteriaResponse.self, from: data)
                
                var results = [String]()
                cafeteriaResponse.cafeteriaList.forEach { menu in
                    if (31...35).contains(menu.type) {
                        guard let eachMenu = menu.content else {
                            results.append("오늘은 운영하지 않아요 🥲")
                            return
                        }
                        results.append(eachMenu)
                    }
                }
                
                let todayIndex = DateManager.shared.todayIndex()
                
                let todayResult = results[todayIndex].split(separator: "\r\n").map {
                    String($0)
                }
                
                let staffMenu = self.parseStaffMenu(from: todayResult)
                let studentMenu = self.parseStudentMenu(from: todayResult, startIndex: staffMenu.count+1)
                
                completion(.success(Restaurant(staff: staffMenu, student: studentMenu)))
            } catch {
                completion(.failure(APIError.jsonConvertError))
            }
        }
        task.resume()
    }
    
    //오늘 전체 메뉴 중 교직원 식당 메뉴 추출
    func parseStaffMenu(from dayResult: [String]) -> [String] {
        var staffMenu = [String]()
        
        if dayResult.count <= 1 {
            staffMenu = dayResult
        } else {
            for i in stride(from: 1, to: dayResult.count, by: 1) {
                if dayResult[i].contains("학생") {
                    break
                }
                staffMenu.append(dayResult[i])
            }
        }
        
        return staffMenu
    }
    
    //오늘 전체 메뉴 중 학생 식당 메뉴 추출
    func parseStudentMenu(from dayResult: [String], startIndex: Int) -> [String] {
        var studentMenu = [String]()
        
        if startIndex >= dayResult.endIndex {
            studentMenu = ["오늘은 운영하지 않아요 🥲"]
        } else {
            for i in stride(from: startIndex, to: dayResult.count, by: 1) {
                studentMenu.append(dayResult[i])
            }
        }
        
        return studentMenu
    }
}
