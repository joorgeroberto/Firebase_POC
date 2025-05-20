//
//  Login.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 13/05/25.
//

import SwiftUI

struct Login: View {
    @ObservedObject var viewModel: LoginViewModel
//
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
//            ScrollView {
                VStack {
                    Image("woman-reading")
                        .resizable()
                        .scaledToFit()
                        .padding(18)

                    CustomTextField(
                        label: "Email",
                        placeholder: "email@email.com",
                        binding: $viewModel.email
                    )

                    CustomSecureField(
                        label: "Password",
                        placeholder: "**********",
                        binding: $viewModel.password
                    )

                    Button(action: {
                        Task {
                            try await viewModel.signInWithEmailAndPassword()
                        }
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.top, 15)
                    .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)

                    HStack {
                        Text("Don't have an account yet?")
                        NavigationLink("Sign Up", destination: SignUp())
                    }
                    .padding(.top, 10)

                    Button(action: {
                        Task {
                            viewModel.signOut()
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.top, 15)

                    Button(action: {
                        Task {
                            await viewModel.deleteAccount()
                        }
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.top, 15)
                }
                .frame(maxWidth: .infinity)
//            }
        }
        .simultaneousGesture(
            TapGesture().onEnded { _ in
                UIApplication.shared.hideKeyboard()
            }
        )
        .alert(viewModel.alertErrorMessage, isPresented: $viewModel.showAlert) {
            Button("OK", role: .destructive) {
                viewModel.onCloseErrorAlert()
            }
        } message: {
            Text("Please try again.")
        }
    }

    func CustomTextField(label: String, placeholder: String, binding: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
            TextField(placeholder, text: binding)
                .textFieldStyle(.plain)
                .padding(.top, 5)
            Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .opacity(0.5)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
    }

    func CustomSecureField(label: String, placeholder: String, binding: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
            SecureField(text: binding, prompt: Text(placeholder)) {
                Text(label)
            }
            .textFieldStyle(.plain)
            .padding(.top, 5)
            Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .opacity(0.5)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}

#Preview {
    Login()
}
