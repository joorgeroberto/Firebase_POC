//
//  CreateBookViewModel.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//

import SwiftUI

class CreateBookViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertErrorMessage = ""
    var firebaseService: FirebaseService

    init(firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
    }

    func createBook() async throws {
        let book = Book(name: "Memórias Póstumas de Brás Cubas", author: "Machado de Assis")
        do {
            try await firebaseService.createBook(book: book)
        } catch {
            alertErrorMessage = "Error Creating a Book"
            self.showAlert = true
        }
    }

    func createQuote() async throws {
        let quote = Quote(text: "Nova Quote para o livro de Machado de Assis", bookId: "89BD93DD-15D5-4082-8CE0-11AF1D0BC1C2")
        do {
            try await firebaseService.createQuote(quote: quote)
        } catch {
            alertErrorMessage = "Error Creating a Quote"
            self.showAlert = true
        }
    }

    func onCloseErrorAlert() {
        self.showAlert = false
        alertErrorMessage = ""
    }
}
