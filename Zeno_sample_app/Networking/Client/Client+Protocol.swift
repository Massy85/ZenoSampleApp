//
//  Client+Protocol.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from request: URLRequest, completion: @escaping (Result) -> Void)
}

class Client: HTTPClient {
    func get(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any]
                    let theJSONData = try JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
                    let theJSONText = String(data: theJSONData, encoding: .ascii)
                    print("JSON string = \(theJSONText!)")
                } catch {
                    print("Error on decoding: \(error)")
                }
                
                let result = (data, response)
                completion(.success(result))
            }
        }.resume()
    }
}
