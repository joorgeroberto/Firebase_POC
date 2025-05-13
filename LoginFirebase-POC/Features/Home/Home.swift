//
//  Home.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//

import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.books, id: \.id) { book in
                    NavigationLink {
                        // TODO: Remove force Unwrap
                        QuotesList(viewModel: QuotesListViewModel(bookId: book.id!))
                    } label: {
                        Text(book.name)
                    }
                }
            }

            NavigationLink(destination: CreateBook()) {
                Text("SCAN")
                    .font(.headline)
            }
        }
        .onAppear() {
            Task {
                try await viewModel.fetchAllBooks()
            }
        }
    }
}


#Preview {
    Home()
}
