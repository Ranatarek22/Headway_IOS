//
//  NetworkManager.swift
//  IOSproj
//
//  Created by Rana Tarek on 28/01/2025.
//

import Foundation


extension Encodable {
    var asDictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}

struct Status: Codable {
    let code: Int
    let errorMsg: String?
    let error: String?
    let errorData: ErrorData?
    
    struct ErrorData: Codable {
        let smsTime: Double?
    }
}

struct BusinessError: Error {
    let errorType: NetworkRequestError?
    let errorObject: Status?
    
    var errorMessage: String? {
        if errorType == .noInternet {
            return "No internet"
        }
        return errorObject?.errorMsg
    }
}


private func handleError(_ error: Error) -> BusinessError {
    switch error {
    case is Swift.DecodingError:
        return BusinessError(errorType: .decodingError(error.localizedDescription), errorObject: nil)
    case let urlError as URLError:
        return BusinessError(errorType: .urlSessionFailed(urlError), errorObject: nil)
    case let error as BusinessError:
        return error
    default:
        return BusinessError(errorType: .unknownError, errorObject: nil)
    }
}

let validStatus = 200...299

class NetworkManager: NSObject {
    private var urlSession: URLSession!
    static var shared = NetworkManager(session: .shared)
    
    private init(session: URLSession) {
        super.init()
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        self.urlSession.configuration.timeoutIntervalForRequest = 30
    }
    
    func sendRequest<T: Codable>(modelType: T.Type, _ request: Request, completion: @escaping (Result<T, NetworkRequestError>) -> Void) {
        guard let urlRequest = request.asURLRequest(baseURL: APIConstants.baseURL) else {
                completion(.failure(.unknownError))
                return
            }
            
            print("Request URL: \(urlRequest)")
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error as? URLError {
                    print("Request Error: \(error.localizedDescription)")
                    completion(.failure(.urlSessionFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unknownError))
                    return
                }
                
                print("Response Code: \(httpResponse.statusCode)") 
                
                if (500...599).contains(httpResponse.statusCode) {
                    completion(.failure(.error5xx(httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.unknownError))
                    return
                }
                if let responseString = String(data : data , encoding:.utf8) {
                    //print("Response Data : \(responseString)")
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    completion(.failure(.decodingError(error.localizedDescription)))
                }
            }.resume()
        }
}
