//
//  NetworkManager.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/12.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

struct Meal {
    var staff: [String]
    var student: [String]
}

class NetworkManager {
    static let shared = NetworkManager()
    var firestore: Firestore
    
    private init() {
        FirebaseApp.configure()
        firestore = Firestore.firestore()
    }
    
    func TwoRestaurant(day: String, completion: @escaping (Result<Meal, Error>) -> Void) {
        let ref = firestore.collection(day)
        ref.whereField(FieldPath.documentID(), in: ["staffMeal", "studentMeal"]).addSnapshotListener {
            querySnapShot, err in
            if let err = err {
                completion(.failure(err))
            }
            
            var staff = [String]()
            var student = [String]()
            
            for document in querySnapShot!.documents {
                if document.documentID == "staffMeal" {
                    let data = document.data()
                    for i in 0..<data.count {
                        let strIndex = String(i)
                        staff.append(data[strIndex] as! String)
                    }
                } else if document.documentID == "studentMeal"{
                    let data = document.data()
                    for i in 0..<data.count {
                        let strIndex = String(i)
                        student.append(data[strIndex] as! String)
                    }
                }
            }
            completion(.success(Meal(staff: staff, student: student)))
        }
    }
}
