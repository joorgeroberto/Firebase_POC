//
//  SignUpViewModel.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 19/05/25.
//

import SwiftUI
import Combine
import Firebase
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var showAlert = false

    @Published var alertErrorMessage = ""
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var user: User? = nil
    @Published var displayName: String = ""
    @Published var isButtonEnabled = false
    private var cancellables = Set<AnyCancellable>()

    var firebaseService: FirebaseService

    init(firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
        self.setupValidation()
        self.registerAuthStateHandler()
    }

    private func setupValidation() {
        Publishers.CombineLatest3($email, $password, $repeatPassword)
            .map { email, password, repeatPassword in
                return !email.isEmpty && !password.isEmpty && !repeatPassword.isEmpty && password == repeatPassword
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.isButtonEnabled = isEnabled
            }
            .store(in: &cancellables)
    }

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? "(unknown)"
            }
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
    func signUpWithEmailAndPassword() async throws -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await firebaseService.signUpWithEmailAndPassword(email: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed in")
            return true
        } catch {
            print("Erro no sign up: \(error.localizedDescription)")
            showAlert = true
            alertErrorMessage = "Sign Up Error"
            return false
        }
    }

    func refreshSignUpButton() {
        self.isButtonEnabled = !email.isEmpty && !password.isEmpty && !repeatPassword.isEmpty && password == repeatPassword
    }

    func onCloseErrorAlert() {
        self.showAlert = false
        alertErrorMessage = ""
        password = ""
    }
}
