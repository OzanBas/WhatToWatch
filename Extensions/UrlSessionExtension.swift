//
//  APICalls.swift
//  WhatToWatch?
//
//  Created by Ozan Bas on 17.01.2022.
//

import Foundation


extension URLSession {
    
    enum DataError: Error {
        case urlError
        case dataError
        case sessionError
        case serializationError
    }
    
    
    func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
        
        
        guard let url = url else {
            completion(.failure(DataError.urlError))
            return
        }

        let task = dataTask(with: url) { data, _, error in
            guard let data =  data else {
                if let error = error {
                    completion(.failure(error))
                }
                completion(.failure(DataError.dataError))

                return
            }
            
            do {
                print(url)
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(DataError.serializationError))
                print(error)
            }
        }
        task.resume()
    }
    

}
    

