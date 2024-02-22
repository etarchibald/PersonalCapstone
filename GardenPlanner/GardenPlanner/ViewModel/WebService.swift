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

class WebService: Codable {
    func downloadData<T: Codable>(fromURL url: URL) async -> T? {
            do {
//                guard let url = else { throw NetworkError.badUrl }
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
                guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
                
                return decodedResponse
            } catch NetworkError.badUrl {
                print("There was an error creating the URL")
            } catch NetworkError.badResponse {
                print("Did not get a valid response")
            } catch NetworkError.badStatus {
                print("Did not get a 2xx status code from the response")
            } catch NetworkError.failedToDecodeResponse {
                print("Failed to decode response into the given type")
            } catch {
                print("An error occured downloading the data")
            }
            
            return nil
        }
}
