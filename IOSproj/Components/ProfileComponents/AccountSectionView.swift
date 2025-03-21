
import SwiftUI

struct AccountSectionView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var languageManager: LanguageManager
    @State private var isPasswordPromptVisible = false
    @State private var isProcessing = false
    @State private var password: String = ""

    var body: some View {
        Section(LocalizedStringKey("account")) {  
            Button {
                Task {
                    viewModel.signOut()
                }
            } label: {
                SettingsRowView(imageName: "arrow.left.circle.fill", title:
              "sign_out"
                                   , tintColor: .red)
            }

            Button {
                isPasswordPromptVisible = true
            } label: {
                SettingsRowView(imageName: "xmark.circle.fill", title: "delete_account", tintColor: .red)
            }

            Button {
                languageManager.toggleLanguage()
            } label: {
                SettingsRowView(imageName: "globe", title:
                                    "change_language", tintColor: .blue)
            }
        }
        .sheet(isPresented: $isPasswordPromptVisible) {
            PasswordPromptView(password: $password, isProcessing: $isProcessing)
        }
        .environment(\.layoutDirection, languageManager.layoutDirection)
   
    }
}

#Preview {
    AccountSectionView()
}
