import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var email = "" {
        didSet { validateEmail() }
    }
    @Published var fullName = "" {
        didSet { validateFullName() }
    }
    @Published var mobileNumber = "" {
        didSet { validateMobileNumber() }
    }
    @Published var password = "" {
        didSet { validatePassword() }
    }
    @Published var confirmPassword = "" {
        didSet { validateConfirmPassword() }
    }
    
    @Published var emailError = ""
    @Published var fullNameError = ""
    @Published var mobileNumberError = ""
    @Published var passwordError = ""
    @Published var confirmPasswordError = ""
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required."
        } else if !email.isValidEmail() {
            emailError = "Please enter a valid email address."
        } else {
            emailError = ""
        }
    }
    
    private func validateFullName() {
        fullNameError = fullName.isEmpty ? "Full Name is required." : ""
    }
    
    private func validateMobileNumber() {
        if mobileNumber.isEmpty {
            mobileNumberError = "Mobile Number is required."
        } else if !mobileNumber.isValidPhoneNumber() {
            mobileNumberError = "Please enter a valid phone number starts by country code"
        } else {
            mobileNumberError = ""
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required."
        } else if !password.isValidPassword() {
            passwordError = "Password must include uppercase, lowercase, number, special character, and be at least 8 characters long."
        } else {
            passwordError = ""
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password."
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match."
        } else {
            confirmPasswordError = ""
        }
    }
}
