//
//  CatchItCoreTests.swift
//  CatchItCoreTests
//
//  Created by Hadi Zamani on 5/15/20.
//  Copyright © 2020 SomeSimpleSolutions. All rights reserved.
//

import XCTest
@testable import CatchItCore

class SearchSeacurityTests: XCTestCase {
    
    var security: Security!

    override func setUpWithError() throws {
        security = Security()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGivenSearchTermIsEmptySearchMethodReturnsEmptyArray() throws {
        let result = security.search(for: "")

        XCTAssertTrue(result.isEmpty)
    }
    
    func testGivenSearchTermIsNotFoundSearchMethodReturnsEmptyArray() throws {
        let result = security.search(for: "NoSecurity")

        XCTAssertTrue(result.isEmpty)
    }
    
    func testGivenSearchTermIsFoundSearchMethodReturnsNonEmptyArray() throws {
        let result = security.search(for: "Security")

        XCTAssertFalse(result.isEmpty)
    }
}
