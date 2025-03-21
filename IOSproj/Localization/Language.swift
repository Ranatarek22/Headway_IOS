//
//  Language.swift
//  IOSproj
//
//  Created by Rana Tarek on 31/01/2025.
//

import Foundation


enum Language: String, CaseIterable {
    case english = "en"
    case arabic = "ar"

    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .arabic:
            return "العربية"
        }
    }
}
