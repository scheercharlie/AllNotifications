//
//  APIClient.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/2/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

class APIClient {
    //Base API request that takes no special Headers
    static func ApiTaskRequest<ResponseType: Decodable, ErrorType: DecodeableError>(url: URL, method: String, responseType: ResponseType.Type, body: Data?, errorType: ErrorType.Type, completion: @escaping (ResponseType?,  Error?) -> Void ) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.httpBody = body
        }
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    //If fetching data has failed return system error
                    completion(nil, error)
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedData = try jsonDecoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    //If receiving data and decoding data succeeds, return data
                    completion(decodedData, nil)
                }
            } catch {
                do {
                    let errorResponse = try jsonDecoder.decode(ErrorType.self, from: data)
                    DispatchQueue.main.async {
                        //If receiving data succeeds but decoding fails, return decoding error
                        print(errorResponse)
                        completion(nil, errorResponse)
                    }
                } catch {
                    print(error)
                }
            }
        }
        session.resume()
    }
    
    //Base API request including HTTP headers
    static func ApiTaskRequestWithHeaders<ResponseType: Decodable, ErrorType: DecodeableError>(url: URL, method: String, responseType: ResponseType.Type, body: Data?, headers: [HTTPHeaders], errorType: ErrorType.Type, completion: @escaping (ResponseType? , Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.httpBody = body
        }
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.field)
        }

        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    //If fetching data has failed return system error
                    completion(nil, error)
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
//            let json = try? JSONSerialization.jsonObject(with: data, options: [])
//            print(json)
            
            do {
                let decodedData = try jsonDecoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    //If receiving data and decoding data succeeds, return data
                    completion(decodedData, nil)
                }
            } catch {
                do {
                    print(error)
                    let errorResponse = try jsonDecoder.decode(ErrorType.self, from: data)
                    DispatchQueue.main.async {
                        //If receiving data succeeds but decoding fails, return decoding error
                        completion(nil, errorResponse)
                    }
                } catch {
                    print(error)
                }
            }
        }
        session.resume()
    }
    

}

