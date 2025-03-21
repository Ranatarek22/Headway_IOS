//
//  InputView.swift
//  FinalProject
//
//  Created by Rana Tarek on 24/01/2025.
//

import SwiftUI
struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)

            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .keyboardType(keyboardType)
            }

            Divider()
                .background(Color.gray)
        }
    }
}
#Preview {
    InputView(text:.constant("")
              ,title:"Email Address",placeholder: "test@email")
}
