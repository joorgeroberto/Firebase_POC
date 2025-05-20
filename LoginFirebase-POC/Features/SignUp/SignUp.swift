//
//  SignUp.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 19/05/25.
//

import SwiftUI

struct SignUp: View {
    @ObservedObject var viewModel: SignUpViewModel
//
    init(viewModel: SignUpViewModel = SignUpViewModel()) {
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

                    CustomSecureField(
                        label: "Repeat Password",
                        placeholder: "**********",
                        binding: $viewModel.repeatPassword
                    )

                    Button(action: {
                        Task {
                            try await viewModel.signUpWithEmailAndPassword()
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(viewModel.isButtonEnabled ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .padding(.top, 15)
                    .disabled(!viewModel.isButtonEnabled)
                }
                .frame(maxWidth: .infinity)
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

#Preview {
    SignUp()
}
