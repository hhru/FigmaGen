//
//  FigmaGenDemoTests.swift
//  FigmaGenDemoTests
//
//  Created by Almaz Ibragimov on 08.02.2020.
//  Copyright © 2020 Almaz Ibragimov. All rights reserved.
//

import XCTest
import FigmaGenDemo

class FigmaGenDemoTests: XCTestCase {

    func testImages() throws {
        try Images.validate()
    }

    func testTextStyles() throws {
        try TextStyle.validate()
    }

    func testTypographies() throws {
        try Typography.validate()
    }
}
