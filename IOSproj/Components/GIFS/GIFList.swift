////
////  GIFList.swift
////  IOSproj
////
////  Created by Rana Tarek on 29/01/2025.
////
//



import SwiftUI
import SDWebImageSwiftUI

struct GIFList: View {
    @StateObject var viewModel: GIFViewModel
    @Binding var searchQuery: String

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 10) {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.gifs.isEmpty {
                    Text("No GIFs found.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ForEach(viewModel.gifs, id: \.id) { realmGif in
                        GIFRow(gif: realmGif , viewModel: viewModel)
                    }
                }
            }
            .padding()
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scrollView")).minY)
                }
                .frame(height: 1)
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    if value < 100 && !viewModel.isFetchingMore && viewModel.canLoadMore {
                        if !searchQuery.isEmpty {
                            viewModel.fetchNextPage(for: searchQuery)
                        }
                    }
                }
            )
        }
        .coordinateSpace(name: "scrollView")
        .refreshable {
            viewModel.fetchGIFs(for: searchQuery)
        }
    }
}
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
