//
//  APIRouter.swift
//  IOSproj
//
//  Created by Rana Tarek on 28/01/2025.
//

import Foundation

class APIRouter {
    struct GetGIFs: Request {
        typealias ReturnType = GIFResponse
        var path: String = "/v2/search"
        var method: RequestMethod = .get
        var queryParams: [String: Any]?

        init(query: String, limit: Int = 10, pos: String? = nil) {
            queryParams = [
                "q": query,
                "key": NetworkRequest.token,
                "client_key": NetworkRequest.clientId,
                "limit": limit
            ]
            if let pos = pos {
                queryParams?["pos"] = pos
            }
        }
    }
}
