//
//  CreateUser.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//

import SwiftUI
import CoreData
import FirebaseFirestore

struct CreateUser: View {
    @ObservedObject var viewModel: CreateUserViewModel

    init(viewModel: CreateUserViewModel = CreateUserViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Button("Create User") {
                Task {
                    try await viewModel.createUser()
                }
            }
        }
        .alert("Error Creating User", isPresented: $viewModel.showAlert) {
            Button("OK", role: .destructive) {
                viewModel.onCloseErrorAlert()
            }
        } message: {
            Text("Please try again.")
        }
    }

}

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var profilePictureURL: String?
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
