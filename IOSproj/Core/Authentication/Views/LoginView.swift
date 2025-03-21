import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    Image("login")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)

                    VStack(spacing: 16) {
                      
                        InputView(
                            text: $loginViewModel.email,
                            title: "Email Address",
                            placeholder: "Enter your email"
                        )
                        .autocapitalization(.none)
                        if !loginViewModel.emailError.isEmpty {
                            Text(loginViewModel.emailError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, -16)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }

                        
                        InputView(
                            text: $loginViewModel.password,
                            title: "Password",
                            placeholder: "Enter your password",
                            isSecureField: true
                        )
                        if !loginViewModel.passwordError.isEmpty {
                            Text(loginViewModel.passwordError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, -16)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }

                        HStack {
                            Spacer()
                            Button(action: {
                                print("Forgot Password tapped")
                            }) {
                                Text("Forgot Password?")
                                    .foregroundColor(AuthColors.primary)
                                    .font(.footnote)
                            }
                        }
                    }

                 
                    AuthButton(title: "SIGN IN") {
                        if loginViewModel.isValidForm {
                            Task {
                                await viewModel.signIn(
                                    withEmail: loginViewModel.email,
                                    password: loginViewModel.password
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                NavigationLink(destination: RegisterationView().navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        Text("Sign up")
                            .fontWeight(.bold)
                            .foregroundColor(AuthColors.primary)
                    }
                    .font(.system(size: 14))
                }
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 16)

            .toast(isPresented: $viewModel.showToast, message: viewModel.toastMessage, type: viewModel.toastType)
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
