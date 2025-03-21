import SwiftUI

struct PasswordPromptView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var password: String
    @Binding var isProcessing: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 16) {
            Text("Enter your password to delete account")
                .font(.headline)
                .padding()

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            if isProcessing {
                ProgressView()
            } else {
                Button("Confirm Deletion") {
                    Task {
                        isProcessing = true
                        let success = await viewModel.deleteAccount(password: password)
                        isProcessing = false
                        if success {
                            viewModel.toastMessage = "Account deleted successfully"
                            viewModel.toastType = .success
                            viewModel.showToast = true
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.toastMessage = "Account deletion failed"
                            viewModel.toastType = .error
                            viewModel.showToast = true
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(password.isEmpty)
                .toast(isPresented: $viewModel.showToast, message: viewModel.toastMessage, type: viewModel.toastType)
            }
        }
        .padding()
    }
}

#Preview {
    PasswordPromptView(
        password: .constant(""),
        isProcessing: .constant(false)
    )
    .environmentObject(AuthViewModel())
}

