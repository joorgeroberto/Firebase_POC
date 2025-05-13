//
//  HomeViewModel.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//

import SwiftUI
import Firebase

class HomeViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertErrorMessage = ""
    @Published var books: [Book] = []

    var firebaseService: FirebaseService

    init(firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    @MainActor
    func fetchAllBooks() async throws {
        Task {
            do {
                self.books = try await firebaseService.fetchAllBooks()
            } catch {
                showAlert = true
                alertErrorMessage = "Error Fetching Books"
            }
        }
    }

    func onCloseErrorAlert() {
        self.showAlert = false
        alertErrorMessage = ""
    }
}
