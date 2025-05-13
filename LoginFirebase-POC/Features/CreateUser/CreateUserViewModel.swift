//
//  CreateUserViewModel.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//

import SwiftUI

class CreateUserViewModel: ObservableObject {
    @Published var showAlert = false
    var firebaseService: FirebaseService

    init(firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    func createUser() async throws {
        let user = User(name: "Jorge", email: "jorge@email.com")
        do {
            try await firebaseService.createUser(user: user)
        } catch {
            self.showAlert = true
        }
    }

    func onCloseErrorAlert() {
        self.showAlert = false
    }
}
