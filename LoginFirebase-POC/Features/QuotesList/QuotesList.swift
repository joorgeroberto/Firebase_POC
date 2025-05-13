//
//  QuotesList.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//


import SwiftUI

struct QuotesList: View {
    @ObservedObject var viewModel: QuotesListViewModel

    init(viewModel: QuotesListViewModel = QuotesListViewModel(bookId: "")) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.quotes, id: \.id) { quote in
                    NavigationLink {
                        Text(quote.text)
                    } label: {
                        Text(quote.text)
                    }
                }
            }

//            NavigationLink(destination: CreateBook()) {
//                Text("SCAN")
//                    .font(.headline)
//            }
        }
        .onAppear() {
            Task {
                try await viewModel.fetchAllQuotes()
            }
        }
    }
}


#Preview {
    QuotesList()
}
