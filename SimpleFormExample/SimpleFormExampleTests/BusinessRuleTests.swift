//
//  BusinessRuleTests.swift
//  SimpleFormExampleTests
//
//  Created by Ahmad Sallam on 22/09/2024.
//

import XCTest
@testable import FormBuilder
@testable import SimpleFormExample

final class BusinessRuleTests: XCTestCase {

    struct MockBusinessRule: BusinessRule {
        var key: String
        var editable: Bool
        var mandatory: Bool
        var maxValue: String
        var minValue: String
        var regex: String
        var showIfMinValue: Bool
        var mandatoryIfMinValue: Bool
    }
    
    // Test case when all conditions are valid
    func testValidate_AllValidConditions() {
        let rule = MockBusinessRule(
            key: "TestKey",
            editable: true,
            mandatory: true,
            maxValue: "100",
            minValue: "10",
            regex: "^\\d+$", // Regex for numeric values
            showIfMinValue: false,
            mandatoryIfMinValue: false
        )

        XCTAssertTrue(rule.validate(), "Validation should pass when all conditions are valid.")
    }

    // Test case when key is empty
    func testValidate_EmptyKey() {
        let rule = MockBusinessRule(
            key: "",
            editable: true,
            mandatory: true,
            maxValue: "100",
            minValue: "10",
            regex: "^\\d+$",
            showIfMinValue: false,
            mandatoryIfMinValue: false
        )

        XCTAssertFalse(rule.validate(), "Validation should fail if the key is empty.")
    }

    // Test case when minValue is greater than maxValue
    func testValidate_MinGreaterThanMax() {
        let rule = MockBusinessRule(
            key: "TestKey",
            editable: true,
            mandatory: true,
            maxValue: "10",
            minValue: "20", // minValue is greater than maxValue
            regex: "^\\d+$",
            showIfMinValue: false,
            mandatoryIfMinValue: false
        )

        XCTAssertFalse(rule.validate(), "Validation should fail if minValue is greater than maxValue.")
    }

    // Test case when regex does not match minValue
    func testValidate_InvalidRegex() {
        let rule = MockBusinessRule(
            key: "TestKey",
            editable: true,
            mandatory: true,
            maxValue: "100",
            minValue: "abc", // Invalid for numeric regex
            regex: "^\\d+$", // Regex only allows numeric values
            showIfMinValue: false,
            mandatoryIfMinValue: false
        )

        XCTAssertFalse(rule.validate(), "Validation should fail if minValue doesn't match the regex.")
    }

    // Test case when showIfMinValue is true but minValue is empty
    func testValidate_ShowIfMinValue_WithEmptyMinValue() {
        let rule = MockBusinessRule(
            key: "TestKey",
            editable: true,
            mandatory: true,
            maxValue: "100",
            minValue: "",
            regex: "^\\d+$",
            showIfMinValue: true,
            mandatoryIfMinValue: false
        )

        XCTAssertFalse(rule.validate(), "Validation should fail if showIfMinValue is true and minValue is empty.")
    }

    // Test case when mandatoryIfMinValue is true but minValue is empty
    func testValidate_MandatoryIfMinValue_WithEmptyMinValue() {
        let rule = MockBusinessRule(
            key: "TestKey",
            editable: true,
            mandatory: true,
            maxValue: "100",
            minValue: "",
            regex: "^\\d+$",
            showIfMinValue: false,
            mandatoryIfMinValue: true
        )

        XCTAssertFalse(rule.validate(), "Validation should fail if mandatoryIfMinValue is true and minValue is empty.")
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
