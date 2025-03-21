//
//  NetworkMonitor.swift
//  IOSproj
//
//  Created by Rana Tarek on 29/01/2025.
//

import Foundation
import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var viewModel: GIFViewModel?

    init(viewModel: GIFViewModel) {
        self.viewModel = viewModel
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.viewModel?.isOffline = !(path.status == .satisfied)
                if self?.viewModel?.isOffline == true {
                    self?.viewModel?.fetchCachedGIFs()
                } else {
                    self?.viewModel?.fetchGIFs(for: "trending")
                }
            }
        }
        monitor.start(queue: queue)
    }
}
//import Foundation
//import Network
//
//class NetworkMonitor {
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "NetworkMonitor")
//    private weak var viewModel: GIFViewModel?
//
//    init(viewModel: GIFViewModel) {
//        self.viewModel = viewModel
//        startMonitoring()
//    }
//
//    private func startMonitoring() {
//        monitor.pathUpdateHandler = { [weak self] path in
//            DispatchQueue.main.async {
//                let isOffline = !(path.status == .satisfied)
//                self?.viewModel?.isOffline = isOffline
//                print("Network status updated: isOffline = \(isOffline)")
//
//                if isOffline {
//                    self?.viewModel?.fetchCachedGIFs()
//                } else if let query = self?.viewModel?.lastSearchQuery {
//                    self?.viewModel?.fetchGIFs(for: query)
//                }
//            }
//        }
//        monitor.start(queue: queue)
//    }
//
//    deinit {
//        monitor.cancel()
//    }
//}

