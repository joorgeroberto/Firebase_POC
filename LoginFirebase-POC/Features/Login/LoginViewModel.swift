//
//  LoginViewModel.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 13/05/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var showAlert = false
    var isLoginButtonDisabled: Bool = true

    @Published var alertErrorMessage = ""
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var email = ""
    @Published var password = ""
    @Published var user: User? {
        didSet {
            print(user)
        }
    }

    var firebaseService: FirebaseService

    init(firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
        self.registerAuthStateHandler()
    }

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    func registerAuthStateHandler() {
        // TODO: COLOCAR NO USER DEFAULTS!!
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
//                self.displayName = user?.email ?? "(unknown)"
            }
        }
    }

    @MainActor
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            print(error)
            showAlert = true
            alertErrorMessage = "Delete Account Error"
            return false
        }
    }

    @MainActor
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            showAlert = true
            alertErrorMessage = "Sign Out Error"
        }
    }

    @MainActor
    func signInWithEmailAndPassword() async throws {
        Task {
            authenticationState = .authenticating
            do {
                let result = try await firebaseService.signInWithEmailAndPassword(email: email, password: password)
//                autheticationState = .authenticated
                print("Login realizado. UID: \(result.user.uid)")
            } catch {
                print("Erro no login: \(error.localizedDescription)")
                showAlert = true
//                authenticationState = .unauthenticated
                alertErrorMessage = "Login Error"
            }
        }
    }

    func onCloseErrorAlert() {
        self.showAlert = false
        alertErrorMessage = ""
        password = ""
    }
}
