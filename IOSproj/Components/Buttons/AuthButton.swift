//
//  AuthButton.swift
//  FinalProject
//
//  Created by Rana Tarek on 24/01/2025.
//

import SwiftUI

struct AuthButton: View {
    let title:String
    let action:()-> Void
    var backgroundColor: Color=Color(AuthColors.primary)
    var foregroundColor: Color = Color(.white)
    var cornerRadius:CGFloat=10
    var height: CGFloat=48
    var width :CGFloat = UIScreen.main.bounds.width - 32
    
    var body: some View {
        Button(action: action){
            HStack{
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(foregroundColor)
            }
            .frame(width:width,height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .font(.headline)
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    AuthButton(title: "SIGN IN", action: {
        print("Button tapped !")
    })
}
