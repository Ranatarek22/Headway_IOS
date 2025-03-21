////
//  IOSprojApp.swift
//  IOSproj
////
//  Created by Rana Tarek on 25/01/2025.
////


import SwiftUI
import Firebase
import RealmSwift

@main
struct IOSprojApp: App {
    @StateObject var viewModel = AuthViewModel()
   // @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject var languageManager = LanguageManager()
    init() {
        FirebaseApp.configure()

        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
            
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config

        let _ = try! Realm()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(languageManager) 
                .environment(\.locale, languageManager.locale)
                .environment(\.layoutDirection, languageManager.layoutDirection)
        }
    }
}
  


