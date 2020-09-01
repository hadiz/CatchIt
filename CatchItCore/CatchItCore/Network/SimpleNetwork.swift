//
//  SimpleNetwork.swift
//  CatchItCore
//
//  Created by Hadi Zamani on 5/19/20.
//  Copyright © 2020 SomeSimpleSolutions. All rights reserved.
//

import Combine

final class SimpleNetwork {
    
    var session: URLSessionProtocol!
    
    func fetchData(from address: String) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        
        guard let url = URL(string: address) else {
            return Fail<(data: Data, response: URLResponse), URLError>(error: URLError(URLError.badURL)).eraseToAnyPublisher()
        }

        return session.dataTaskAnyPublisher(for: url)
    }
}

extension URLSession: URLSessionProtocol {
    func dataTaskAnyPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return self.dataTaskPublisher(for: url).eraseToAnyPublisher()
    }
}
