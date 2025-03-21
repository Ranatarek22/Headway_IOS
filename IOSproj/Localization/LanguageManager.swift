
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("appLanguage") private var languageCode: String = Locale.current.language.languageCode?.identifier ?? "en"
    @Published var locale: Locale
    @Published var layoutDirection: LayoutDirection

    init() {
        let initialLanguageCode = Locale.current.language.languageCode?.identifier ?? "en"
        self.locale = Locale(identifier: initialLanguageCode)
        self.layoutDirection = (initialLanguageCode == "ar") ? .rightToLeft : .leftToRight
    }

    func toggleLanguage() {
        languageCode = (languageCode == "en") ? "ar" : "en"
        locale = Locale(identifier: languageCode)
        layoutDirection = (languageCode == "ar") ? .rightToLeft : .leftToRight
        DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
    }
}

