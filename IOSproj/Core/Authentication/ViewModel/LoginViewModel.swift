//
//  LoginViewModel.swift
//  IOSproj
//
//  Created by Rana Tarek on 27/01/2025.
//

import Foundation

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = "" {
        didSet { validateEmail() }
    }
    @Published var password = "" {
        didSet { validatePassword() }
    }

    @Published var emailError = ""
    @Published var passwordError = ""

    var isValidForm: Bool {
        emailError.isEmpty && passwordError.isEmpty
    }

    private func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required."
        } else if !email.isValidEmail() {
            emailError = "Please enter a valid email address."
        } else {
            emailError = ""
        }
    }

    private func validatePassword() {
        passwordError = password.isEmpty ? "Password is required." : ""
    }
}
