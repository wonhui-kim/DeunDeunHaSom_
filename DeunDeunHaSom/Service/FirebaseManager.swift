//
//  FirebaseManager.swift
//  DeunDeunHaSom
//
//  Created by kim-wonhui on 2023/11/03.
//

import Foundation

import Firebase
import FirebaseFirestore

enum FirebaseError: Error {
    case invalidData
    case jsonConvertError
    case unknownError
}

final class FirebaseManager {
    static let shared = FirebaseManager()
    var firestore: Firestore
    
    private init() {
        FirebaseApp.configure()
        firestore = Firestore.firestore()
    }
    
    //throws 함수로 에러 발생 가능성 내포
    func fetchSeparator() async throws -> String {
        let query = firestore.collection("separator").document("id")
        let data = try await query.getDocument().data()
        
        //왜 Any as String 안되고, as? as!는 되나
        guard let data = data,
              let value = data["value"],
              let separator = value as? String else {
            throw FirebaseError.invalidData
        }
        //각 값에서 유효한 값이 없을 경우 invalidData 에러 throw(던짐)
        
        return separator
    }
}
