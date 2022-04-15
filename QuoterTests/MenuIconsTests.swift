//
//  TestFileTest.swift
//  QuoterTests
//
//  Created by Lado Tsivtsivadze on 4/14/22.
//

import XCTest
@testable import Quoter

class MenuIconsTests: XCTestCase {
    
    let sut = MenuIcons.defaultIcon

    func testDefaultIconIsNotNil() {
        XCTAssertNotNil(sut)
    }

}
