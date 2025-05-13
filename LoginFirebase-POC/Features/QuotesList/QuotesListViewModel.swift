//
//  QuotesListViewModel.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//


import SwiftUI

class QuotesListViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertErrorMessage = ""
    @Published var quotes: [Quote] = []
    @Published var bookId: String

    var firebaseService: FirebaseService

    init(bookId: String, firebaseService: FirebaseService = FirebaseService()) {
        self.bookId = bookId
        self.firebaseService = firebaseService
    }

    @MainActor
    func fetchAllQuotes() async throws {
        Task {
            do {
                self.quotes = try await firebaseService.fetchAllQuotesByBook(forBookID: self.bookId)
            } catch {
                showAlert = true
                alertErrorMessage = "Error Fetching Quotes"
            }
        }
    }

    func onCloseErrorAlert() {
        self.showAlert = false
        alertErrorMessage = ""
    }
}
