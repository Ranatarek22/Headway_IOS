//////
//////  GIFRow.swift
//////  IOSproj
//////
//////  Created by Rana Tarek on 29/01/2025.
//////
////
////import SwiftUI
////import SDWebImageSwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct GIFRow: View {
    let gif: GIFRealmModel
    @ObservedObject var viewModel: GIFViewModel
   
    @State private var cachedURL: URL?

    var body: some View {
        NavigationLink(destination: DetailsScreenView()) {
            VStack {
                if let cachedURL = cachedURL, FileManager.default.fileExists(atPath: cachedURL.path) {
                    WebImage(url: cachedURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                } else if let url = URL(string: gif.tinygifURL) {
            
                    WebImage(url: url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onAppear {
                            viewModel.cacheGIFImage(url: url) { localURL in
                                if let localURL = localURL {
                                    DispatchQueue.main.async {
                                        self.cachedURL = localURL
                                    }
                                }
                            }
                        }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
            }
        }
    }
}
