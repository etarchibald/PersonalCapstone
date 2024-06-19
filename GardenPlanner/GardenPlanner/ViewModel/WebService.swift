//
//  WebService.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

class WebService {
    
    func downloadData<T: Codable>(fromURL url: URL) async -> T? {
        do {
            let session = URLSession(configuration: .default, delegate: URLSessionDelegateHandler(), delegateQueue: nil)
            
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.badStatus
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.failedToDecodeResponse
            }
        } catch {
            print(error)
            return nil
        }
    }
}

class URLSessionDelegateHandler: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
}
