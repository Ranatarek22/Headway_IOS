//
//  RegisterationView.swift
//  FinalProject
//
//  Created by Rana Tarek on 24/01/2025.
//

import SwiftUI


struct RegisterationView: View {
    @StateObject private var registerViewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    var body: some View {
        ScrollView{
            VStack {
                Image("login").padding(.vertical, 10)
                
                ScrollView{
                    VStack(spacing: 24) {
                     
                        InputView(
                            text: $registerViewModel.fullName,
                            title: "Full Name",
                            placeholder: "Enter your full name"
                        )
                        if !registerViewModel.fullNameError.isEmpty {
                            Text(registerViewModel.fullNameError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, -16)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                        

                        InputView(
                            text: $registerViewModel.email,
                            title: "Email Address",
                            placeholder: "text@mail.com"
                        ).autocapitalization(.none)
                        if !registerViewModel.emailError.isEmpty {
                            Text(registerViewModel.emailError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, -16)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                        
                     
                        InputView(
                            text: $registerViewModel.mobileNumber,
                            title: "Mobile Number",
                            placeholder: "Enter your mobile number",
                            keyboardType: .phonePad
                        )
                        if !registerViewModel.mobileNumberError.isEmpty {
                            Text(registerViewModel.mobileNumberError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, -16)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                        
                     
                        InputView(
                            text: $registerViewModel.password,
                            title: "Password",
                            placeholder: "Enter your password",
                            isSecureField: true
                        )
                        if !registerViewModel.passwordError.isEmpty {
                            Text(registerViewModel.passwordError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, -16)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                        

                        InputView(
                            text: $registerViewModel.confirmPassword,
                            title: "Confirm Password",
                            placeholder: "Confirm your password",
                            isSecureField: true
                        )
                        if !registerViewModel.confirmPasswordError.isEmpty {
                            Text(registerViewModel.confirmPasswordError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, -16)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                }
          
                AuthButton(title: "SIGN UP") {
                    
                    if registerViewModel.emailError.isEmpty &&
                        registerViewModel.fullNameError.isEmpty &&
                        registerViewModel.mobileNumberError.isEmpty &&
                        registerViewModel.passwordError.isEmpty &&
                        registerViewModel.confirmPasswordError.isEmpty {
                        
                        Task {
                            try await viewModel.createUser(
                                withEmail: registerViewModel.email,
                                password: registerViewModel.password,
                                mobileNumber: registerViewModel.mobileNumber,
                                fullName: registerViewModel.fullName
                            )
                        }
                    }
                    
                }
                .toast(isPresented: $viewModel.showToast, message: viewModel.toastMessage, type: viewModel.toastType)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Text("Sign In")
                            .fontWeight(.bold)
                            .foregroundColor(AuthColors.primary)
                    }
                    .font(.system(size: 14))
                }
            }
        }
        }
}

#Preview {
    RegisterationView()
}
