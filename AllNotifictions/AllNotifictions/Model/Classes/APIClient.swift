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
    private func ApiTaskRequer<RequestType: Encodable, ResponseType: Decodable, ErrorResponseType: Decodable>(url: URL, method: String, responseType: ResponseType.Type, body: RequestType, errorResponse: ErrorResponseType.Type, completion: @escaping (ResponseType?, ErrorResponseType?, Error?) -> Void ) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        do {
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(body)
            request.httpBody = data
        } catch {
            print("Could not encode Data")
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    //If fetching data has failed return system error
                    completion(nil, nil, error)
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedData = try jsonDecoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    //If receiving data and decoding data succeeds, return data
                    completion(decodedData, nil, nil)
                }
            } catch {
                do {
                    let errorResponse = try jsonDecoder.decode(ErrorResponseType.self, from: data)
                    DispatchQueue.main.async {
                        //If receiving data succeeds but decoding fails, return decoding error
                        completion(nil, errorResponse, nil)
                    }
                } catch {
                    print(error)
                }
            }
        }
        session.resume()
    }
    
    //Base API request including HTTP headers
    private func ApiTaskRequestWithHeaders<RequestType: Encodable, ResponseType: Decodable, ErrorResponseType: Decodable>(url: URL, method: String, responseType: ResponseType.Type, body: RequestType, errprResponseType: ErrorResponseType.Type, headers: [HTTPHeaders], completion: @escaping (ResponseType?, ErrorResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.field)
        }
        
        do {
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(body)
            request.httpBody = data
        } catch {
            print("Could not encode Data")
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    //If fetching data has failed return system error
                    completion(nil, nil, error)
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedData = try jsonDecoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    //If receiving data and decoding data succeeds, return data
                    completion(decodedData, nil, nil)
                }
            } catch {
                do {
                    let errorResponse = try jsonDecoder.decode(ErrorResponseType.self, from: data)
                    DispatchQueue.main.async {
                        //If receiving data succeeds but decoding fails, return decoding error
                        completion(nil, errorResponse, nil)
                    }
                } catch {
                    print(error)
                }
            }
        }
        session.resume()
    }
    

}
