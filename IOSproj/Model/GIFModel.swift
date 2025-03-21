
import Foundation

struct GIFResponse: Codable {
    let next: String?
    let results: [GIF]
}

struct GIF: Codable {
    let id: String
    let title: String
    let mediaFormats: [String: MediaDetails]

    var tinygifURL: URL? {
        if let tinygifDetails = mediaFormats["tinygif"] {
            return URL(string: tinygifDetails.url)
        }
        return nil
    }

    struct MediaDetails: Codable {
        let url: String
        let size: Int
        let duration: Double
        let preview: String
        let dims: [Int]
    }

    enum CodingKeys: String, CodingKey {
        case id, title
        case mediaFormats = "media_formats"
    }
}
