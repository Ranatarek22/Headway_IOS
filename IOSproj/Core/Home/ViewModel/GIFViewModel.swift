
import Foundation
import RealmSwift

class GIFViewModel: ObservableObject {
    @Published var gifs: [GIFRealmModel] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isFetchingMore: Bool = false
    @Published var canLoadMore: Bool = true
    @Published var isOffline: Bool = false

    private let networkManager = NetworkManager.shared
    private var currentPage = 0
    private let itemsPerPage = 10
    private var nextPos: String?
    private let realm = try! Realm()

    init() {
        _ = NetworkMonitor(viewModel: self)
    }

    func fetchGIFs(for query: String) {
        isLoading = true
        errorMessage = nil
        gifs.removeAll()
        currentPage = 0
        nextPos = nil
        fetchNextPage(for: query)
    }

   
    func fetchNextPage(for query: String) {
        guard !isFetchingMore && canLoadMore else { return }
        isFetchingMore = true
        
        let limit = itemsPerPage
        let pos = nextPos
        let request = APIRouter.GetGIFs(query: query, limit: limit, pos: pos)
        
        networkManager.sendRequest(modelType: GIFResponse.self, request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isFetchingMore = false
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    if response.results.isEmpty {
                        self.canLoadMore = false
                    } else {
                        let realmModels = self.convertToRealmModels(gifs: response.results)
                        self.gifs.append(contentsOf: realmModels)
                        self.nextPos = response.next
                        self.currentPage += 1
                        
                        if query == "trending" {
                            self.saveGIFsToRealm(gifs: realmModels)
                            for gif in response.results {
                                if let url = gif.tinygifURL {
                                    self.cacheGIFImage(url: url, completion: { _ in })
                                }
                            }
                        }
                    }
                case .failure(let error):
                    //self.errorMessage = error.localizedDescription
                    print("API Request Failed: \(error.localizedDescription)")
                    self.fetchCachedGIFs() // Fallback to cached GIFs
                }
            }
        }
    }

    func convertToRealmModels(gifs: [GIF]) -> [GIFRealmModel] {
        return gifs.map { gif in
            let realmModel = GIFRealmModel()
            realmModel.id = gif.id
            realmModel.title = gif.title
            if let tinygifURL = gif.tinygifURL {
                realmModel.tinygifURL = tinygifURL.absoluteString
            }
            return realmModel
        }
    }

    func saveGIFsToRealm(gifs: [GIFRealmModel]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(gifs, update: .modified)
            }
            print("Saved GIFs to Realm: \(gifs.count)")
        } catch {
            print("Error saving GIFs to Realm: \(error)")
        }
    }

    func fetchCachedGIFs() {
        do {
            let realm = try Realm()
            let cachedGIFs = realm.objects(GIFRealmModel.self).sorted(byKeyPath: "createdAt", ascending: false)
            print("Fetched cached GIFs: \(cachedGIFs.count)")
            self.gifs = Array(cachedGIFs)
        } catch {
            print("Error fetching cached GIFs from Realm: \(error)")
        }
    }

    func resetGIFs() {
        gifs = []
        errorMessage = nil
        isLoading = false
        isFetchingMore = false
        canLoadMore = true
        currentPage = 0
        nextPos = nil
    }

    func cacheGIFImage(url: URL, completion: @escaping (URL?) -> Void) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)

        if fileManager.fileExists(atPath: destinationURL.path) {
            print("Image exists at: \(destinationURL.path)")
            completion(destinationURL)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                try data.write(to: destinationURL)
                print("Saved image at: \(destinationURL.path)")
                completion(destinationURL)
            } catch {
                print("Error saving image: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}


