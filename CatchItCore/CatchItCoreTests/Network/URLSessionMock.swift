//
//  URLSessionMock.swift
//  CatchItCoreTests
//
//  Created by Hadi Zamani on 5/28/20.
//  Copyright © 2020 SomeSimpleSolutions. All rights reserved.
//

import Foundation
import Combine
@testable import CatchItCore

internal enum Result {
    case success
    case failure
}

final internal class URLSessionMock : URLSessionProtocol {
    private var expectedResult: Result
    
    init(with expectedResult: Result) {
        self.expectedResult = expectedResult
    }
    
    func dataTaskAnyPublisher(for: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        FakeURLSession.DataTaskPublisher(with: expectedResult).eraseToAnyPublisher()
    }
}

class FakeURLSession {
    
    struct DataTaskPublisher: Publisher {
        
        typealias Output = (data: Data, response: URLResponse)
        typealias Failure = URLError
        
        private var expectedResult: Result
        
        init(with expectedResult: Result) {
            self.expectedResult = expectedResult
        }
        
        func receive<S>(subscriber: S)
            where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
                
                var subscription: Subscription
                
                if expectedResult == .success {
                    subscription = SuccessInner(downstream: subscriber)
                } else {
                    subscription = FailureInner(downstream: subscriber)
                }
                
                subscriber.receive(subscription: subscription)
        }
        
        class SuccessInner<S>: Subscription
        where S : Subscriber, Failure == S.Failure, Output == S.Input {
            
            var downstream: S?
            
            init(downstream: S) {
                self.downstream = downstream
            }
            
            
            func request(_ demand: Subscribers.Demand) {
                _ = downstream?.receive((data: Data(), response: URLResponse()))
                downstream?.receive(completion: .finished)
                downstream = nil
                return
            }
            
            func cancel() {
                downstream = nil
            }
        }
        
        class FailureInner<S>: Subscription
        where S : Subscriber, Failure == S.Failure, Output == S.Input {
            
            var downstream: S?
            
            init(downstream: S) {
                self.downstream = downstream
            }
            
            func request(_ demand: Subscribers.Demand) {
                downstream?.receive(completion: .failure(URLError(URLError.Code.badServerResponse)))
                downstream = nil
                return
            }
            
            func cancel() {
                downstream = nil
            }
        }
    }
}
