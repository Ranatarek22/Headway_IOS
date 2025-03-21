////
//  GIFView.swift
//  IOSproj
//
////  Created by Rana Tarek on 28/01/2025.
////


import SwiftUI
import SDWebImageSwiftUI

struct GIFView: View {
    @StateObject private var viewModel = GIFViewModel()
    @EnvironmentObject var user: AuthViewModel
    @State private var searchQuery: String = "trending"

    var body: some View {
        let name = user.currentUser?.fullName ?? ""
        
        NavigationView {
            VStack {
                NavBarView()
                Text("Hi ,\(name)").bold()
                    .font(.title)
                SearchBar(text: $searchQuery, isDisabled: viewModel.isOffline)
                    .onChange(of: searchQuery) { newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if newValue.isEmpty {
                                //viewModel.fetchGIFs(for: "trending")
                                viewModel.fetchCachedGIFs()
                            } else {
                                viewModel.fetchGIFs(for: newValue)
                            }
                        }
                    }
                GIFList(viewModel: viewModel, searchQuery: $searchQuery)
            }

            .onAppear {
                viewModel.fetchGIFs(for: searchQuery)
            }
            .onChange(of: viewModel.isOffline) { isOffline in
                if isOffline {
                    viewModel.fetchCachedGIFs()
                } else {
                    viewModel.fetchGIFs(for: searchQuery)
                }
            }
        }
    }
}
