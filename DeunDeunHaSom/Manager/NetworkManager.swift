//
//  NetworkManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/12.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

class NetworkManager {
    private let firestore = Firestore.firestore()
    
    func getMultipleAll(restaurant: String, day: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let ref = firestore.collection(restaurant).document("week")
        
        ref.collection(day).getDocuments { (querySnapshot, err) in
            if let err = err {
                completion(.failure(err))
            } else {
                var temp = [String]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    for i in 0..<data.count {
                        let strIndex = String(i)
                        temp.append(data[strIndex] as! String)
                    }
                }
                completion(.success(temp))
            }
        }
    }
}
