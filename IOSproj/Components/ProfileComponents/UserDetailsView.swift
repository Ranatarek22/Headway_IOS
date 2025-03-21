//
//  UserDetailsView.swift
//  IOSproj
//
//  Created by Rana Tarek on 27/01/2025.
//


import SwiftUI

struct UserDetailsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var editedName: String
    @State private var isEditing: Bool = false

    var user: User

    init(user: User) {
        self.user = user
        _editedName = State(initialValue: user.fullName)
    }

    var body: some View {
        Section {
            HStack {
                Text(user.intials)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(Color(.systemGray3))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    if isEditing {
                        TextField("Enter new name", text: $editedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(user.fullName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                    }
                    Text(user.email)
                        .font(.footnote)
                        .accentColor(.gray)
                    Text(user.mobileNumber)
                        .font(.footnote)
                        .accentColor(.gray)
                }

                Spacer()

                Button(action: {
                    if isEditing {
                        viewModel.updateUserName(newName: editedName)
                    }
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Save" : "Edit")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
  
    UserDetailsView(user: User.MOCK_USER)
}
