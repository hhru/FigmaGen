import XCTest

import FigmaGenTests
import FigmaGenToolsTests

var tests = [XCTestCaseEntry]()
tests += FigmaGenTests.__allTests()
tests += FigmaGenToolsTests.__allTests()

XCTMain(tests)
