//
//  FirebaseService.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//
import SwiftUI
import FirebaseFirestore

class FirebaseService {
    private let db = Firestore.firestore()

    func createUser(user: User) async throws {
//        Task {
            try db.collection("users").document(user.id ?? UUID().uuidString).setData(from: user)
//        }
    }
}
