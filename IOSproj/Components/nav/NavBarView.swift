//
//  NavBarView.swift
//  IOSproj
//
//  Created by Rana Tarek on 29/01/2025.
//
import SwiftUI

struct NavBarView: View {
    @EnvironmentObject var user: AuthViewModel
    
    var body: some View {
        HStack {

            Spacer()
            
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .foregroundColor(.blue) 
            }
        }
        .padding()
    }
}
