//
//  URLSessionProtocol.swift
//  CatchItCore
//
//  Created by Hadi Zamani on 5/28/20.
//  Copyright © 2020 SomeSimpleSolutions. All rights reserved.
//

import Combine

protocol URLSessionProtocol {
    func dataTaskAnyPublisher(for: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}
