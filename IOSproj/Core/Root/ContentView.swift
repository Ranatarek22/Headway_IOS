//
//  ContentView.swift
//  FinalProject
//
//  Created by Rana Tarek on 22/01/2025.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group{
            if viewModel.userSession != nil {
                GIFView()
                    .toast(isPresented: $viewModel.showToast, message: viewModel.toastMessage, type: viewModel.toastType)
            }else{
                LoginView()
                
            }
        }
    }
}


#Preview {
    ContentView()
}
