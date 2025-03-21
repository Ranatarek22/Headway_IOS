//
//  ErrorManager.swift
//  IOSproj
//
//  Created by Rana Tarek on 27/01/2025.
//

import Foundation

class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    
    @Published var errorMessage: IdentifiableError?
    
    private init() {}
    
    func handle(error: Error, userMessage: String? = nil) {
        let friendlyMessage = userMessage ?? "An unexpected error occurred. Please try again."
        
       
        print("DEBUG: Error handled - \(error.localizedDescription)")
        
        DispatchQueue.main.async {
            self.errorMessage = IdentifiableError(message: friendlyMessage)
        }
    }
    
    func clearError() {
        DispatchQueue.main.async {
            self.errorMessage = nil
        }
    }
}
