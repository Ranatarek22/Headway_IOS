//
//  AuthViewModel.swift
//  FinalProject
//
//  Created by Rana Tarek on 25/01/2025.
//

import Foundation
import Firebase


struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User? 
    @Published var errorMessage: IdentifiableError?
    @Published var password: String = ""
    @Published var toastMessage: String = ""
    @Published var toastType: ToastType = .success
    @Published var showToast: Bool = false
    private let errorManager = ErrorManager.shared
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                self.userSession = result.user
                await fetchUser()
                toastMessage = "Login Successful!"
                toastType = .success
                showToast = true
            } catch {
                print("DEBUG: Failed to log in with error \(error.localizedDescription)")
                errorManager.handle(error: error, userMessage: "Failed to log in. Please check your email and password.")
                toastMessage = "\(error.localizedDescription)"
                toastType = .error
                showToast = true
            }
        }
    
    func createUser(withEmail email: String, password: String, mobileNumber: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email, mobileNumber: mobileNumber)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            toastMessage = "Sign Up Successful!"
            toastType = .success
            showToast = true
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            errorManager.handle(error: error, userMessage: "Failed to create your account. Please try again.")
            toastMessage = "\(error.localizedDescription)"
            toastType = .error
            showToast = true
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            print("Sign out successfully")
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
            
        }
    }
    
    func reauthenticate(password: String) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await user.reauthenticate(with: credential)
    }
    func deleteAccount(password: String) async -> Bool {
            guard let user = Auth.auth().currentUser else { return false }
        guard let uid = Auth.auth().currentUser?.uid else { return false }

            do {
                try await reauthenticate(password: password)
                try await Firestore.firestore().collection("users").document(uid).delete()
                try await user.delete()
                self.userSession = nil
                self.currentUser = nil
                print("DEBUG: Account successfully deleted.")
                toastMessage = "Your account deleted successfully"
                toastType = .success
                showToast = true
                return true
            } catch {
                self.errorMessage = IdentifiableError(message: "Failed to delete account. Please try again.")
                print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
                toastMessage = "\(error.localizedDescription)"
                toastType = .error
                showToast = true
                return false
            }
        }

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func updateUserName(newName: String) {
            guard let uid = userSession?.uid else { return }
            let docRef = Firestore.firestore().collection("users").document(uid)

            docRef.updateData(["fullName": newName]) { error in
                if let error = error {
                    print("Error updating name: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.currentUser?.fullName = newName
                    }
                }
            }
        }
}
