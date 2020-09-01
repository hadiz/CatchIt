//
//  SimpleNetworkTests.swift
//  CatchItCoreTests
//
//  Created by Hadi Zamani on 5/19/20.
//  Copyright © 2020 SomeSimpleSolutions. All rights reserved.
//

import XCTest
import Combine
@testable import CatchItCore

class SimpleNetworkTests: XCTestCase {
    
    private var storage = Set<AnyCancellable>()
    private var network: SimpleNetwork!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        network = SimpleNetwork()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        for item in storage {
            item.cancel()
        }
    }

    func testEmptyURLPublishesFailure() throws {
        let pub = network.fetchData(from: "")
        
        pub.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.errorCode, URLError.badURL.rawValue)
            }
        }) {
            XCTAssertNil($0)
        }.store(in:&self.storage)
    }
    
    func testNotEmptyURLDoesNotPublishFailure() throws {
        network.session = URLSessionMock(with: .success)
        
        let pub = network.fetchData(from: "apple.com")
        
        pub.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure( _ ):
                XCTFail()
            }
        }) {
            XCTAssertNotNil($0)
        }.store(in:&self.storage)
    }
    
    func testInvalidURLPublishesFailure() throws {
        let pub = network.fetchData(from: "Invalid URL")
        
        pub.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail()
            case .failure(let error):
                
               XCTAssertEqual(error.errorCode, URLError.badURL.rawValue)
            }
        }) {
            XCTAssertNil($0)
        }.store(in:&self.storage)
    }
    
    func testValidURLPublishesResults() throws {
        network.session = URLSessionMock(with: .success)
        
        let pub = network.fetchData(from: "https://apple.com")
        
        pub.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure( _ ):
               XCTFail()
            }
        }) {
            XCTAssertNotNil($0)
        }.store(in:&self.storage)
    }
    
    func testFailureURLPublishesFailure() throws {
        network.session = URLSessionMock(with: .failure)
        
        let pub = network.fetchData(from: "https://apple.com")
        
        pub.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail()
                break
            case .failure(let error):
               XCTAssertNotNil(error)
            }
        }) {
            XCTAssertNil($0)
        }.store(in:&self.storage)
    }
}
