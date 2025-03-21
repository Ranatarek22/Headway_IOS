//
//  ProfileView.swift
//  FinalProject
//
//  Created by Rana Tarek on 24/01/2025.
//


import SwiftUI
struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var errorManager = ErrorManager.shared
    @StateObject private var languageManager = LanguageManager()

    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                ZStack {
                    List {
                        if let user = viewModel.currentUser {
                            UserDetailsView(user: user)
                            SettingsSectionView()
                            AccountSectionView()
                            
                        }
                    }
                    .alert(item: $errorManager.errorMessage) { error in
                        Alert(
                            title: Text("Error"),
                            message: Text(error.message),
                            dismissButton: .default(Text("OK")) {
                                errorManager.clearError()
                            }
                        )
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchUser()
            }
        }
    }
}
