//
//  FirebaseService.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//
import SwiftUI
import FirebaseFirestore

struct Book: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var author: String
    var cover: String?
}

struct Quote: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var bookId: String
}

enum Collections: String {
    case books = "books"
    case quotes = "quotes"
}

enum CommonsErrors: Error {
    case invalidData
    case invalidId
    case networkError
}

class FirebaseService {
    private let db = Firestore.firestore()

    // MARK: BOOKS
    func createBook(book: Book) async throws {
        try await createDocument(collection: Collections.books.rawValue, data: book)
    }

    func updateBook(book: Book) async throws {
        guard let id = book.id else { throw CommonsErrors.invalidId }
        try await updateDocument(collection: Collections.books.rawValue, data: book, id: id)
    }

    func fetchAllBooks() async throws -> [Book] {
        let snapshot = try await db.collection(Collections.books.rawValue).getDocuments()
        let books: [Book] = try snapshot.documents.map { document in
            try document.data(as: Book.self)
        }
        return books
    }

    // MARK: QUOTES
    func createQuote(quote: Quote) async throws {
        try await createDocument(collection: Collections.quotes.rawValue, data: quote)
    }

    func updateQuote(quote: Quote) async throws {
        guard let id = quote.id else { throw CommonsErrors.invalidId }
        try await updateDocument(collection: Collections.quotes.rawValue, data: quote, id: id)
    }

    func fetchAllQuotesByBook(forBookID bookId: String) async throws -> [Quote] {
        let snapshot = try await db.collection(Collections.quotes.rawValue)
            .whereField("bookId", isEqualTo: bookId)
            .getDocuments()

        return try snapshot.documents.map { try $0.data(as: Quote.self) }
    }

}

private extension FirebaseService {
    func createDocument<T: Encodable>(collection: String, data: T, id: String? = nil) async throws {
        let documentID = id ?? UUID().uuidString
        try db.collection(collection).document(documentID).setData(from: data)
    }

    func updateDocument<T: Encodable>(collection: String, data: T, id: String) async throws {
        try db.collection(collection).document(id).setData(from: data, merge: true)
    }
}
