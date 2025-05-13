//
//  CreateBook.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//

import SwiftUI
import CoreData
import FirebaseFirestore

struct CreateBook: View {
    @ObservedObject var viewModel: CreateBookViewModel

    init(viewModel: CreateBookViewModel = CreateBookViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Button(action: {
                Task {
                    try await viewModel.createBook()
                }
            }) {
                Text("Create Book")
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                    .cornerRadius(30)
            }

            Button(action: {
                Task {
                    try await viewModel.createQuote()
                }
            }) {
                Text("Create Quote")
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                    .cornerRadius(30)
            }
        }
        .alert(viewModel.alertErrorMessage, isPresented: $viewModel.showAlert) {
            Button("OK", role: .destructive) {
                viewModel.onCloseErrorAlert()
            }
        } message: {
            Text("Please try again.")
        }
    }

}

#Preview {
    CreateBook()
}
