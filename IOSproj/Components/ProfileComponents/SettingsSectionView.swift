//
//  SettingsSectionView.swift
//  IOSproj
//
//  Created by Rana Tarek on 27/01/2025.
//

import SwiftUI

struct SettingsSectionView: View {
    var body: some View {
        Section("General") {
            HStack {
                SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                Spacer()
                Text("1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    SettingsSectionView()
}
