//
//  SimpleFormExampleTests.swift
//  SimpleFormExampleTests
//
//  Created by Ahmad on 21/08/2024.
//

import XCTest
@testable import FormBuilder
@testable import SimpleFormExample

// Mock JSON Data for testing
let validJSON = """
{
    "fields": [
        {
            "fieldID": "1",
            "label": "Name",
            "value": {"value": "John Doe"},
            "rules": []
        }
    ]
}
""".data(using: .utf8)!

let invalidJSON = """
{
    "invalidKey": "value"
}
""".data(using: .utf8)!



final class SimpleFormExampleTests: XCTestCase {

    func testFormModelParsing() {
        guard let jsonData = ContentView().loadFormJSONToData() else { return }

        let formModel = FormModel(from: jsonData)

        XCTAssertEqual(formModel.fields.count, 26, "The number of fields should match the JSON.")

        // Check first field
        let firstField = formModel.fields.first
        XCTAssertEqual(firstField?.fieldID, "eventTitle", "The first field's ID should be 'eventTitle'.")
        XCTAssertEqual(firstField?.label, "Event Title", "The first field's label should be 'Event Title'.")
        XCTAssertEqual(firstField?.type?.rawValue, "text", "The first field's type should be 'text'.")

        // Check for the second field rules
        let secondField = formModel.fields[1]
        XCTAssertEqual(secondField.rules?.count, 1, "The second field should have one rule.")
        let rule = secondField.rules?.first
        XCTAssertEqual(rule?.condition?.dependsOn, "eventTitle", "The second field should depend on 'eventTitle'.")
    }

    func testEmailFieldValidation() {
        guard let jsonData = ContentView().loadFormJSONToData() else { return }

        let formModel = FormModel(from: jsonData)

        let emailField = formModel.fields.first { $0.fieldID == "email" }
        XCTAssertNotNil(emailField, "Email field should be present.")

        let regex = emailField?.validation?.regex
        XCTAssertEqual(regex, "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", "The email field should have a valid regex.")

        // Simulate email validation
        let isValid = emailField?.validation?.regex == regex
        XCTAssertTrue(isValid, "Email 'test@example.com' should be valid.")
    }

    

    func testInitializationWithValidJSON() {
        guard let jsonData = ContentView().loadFormJSONToData() else { return }

        // Test that FormModel initializes with valid JSON data
        let formModel = FormModel(from: jsonData)
        XCTAssertEqual(formModel.fields.count, 26)
        XCTAssertEqual(formModel.fields.first?.label, "Event Title")
    }

    func testInitializationWithInvalidJSON() {
        // Test that FormModel handles invalid JSON gracefully
        let formModel = FormModel(from: invalidJSON)
        XCTAssertTrue(formModel.fields.isEmpty)
    }

    func testDateFormatting() {
        guard let jsonData = ContentView().loadFormJSONToData() else { return }

        // Test date formatting logic
        let formModel = FormModel(from: jsonData)
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let formattedDate = formModel.formattedDate(date)
        XCTAssertEqual(formattedDate, "1970-01-01")
    }

    func testValidate() {
        guard let jsonData = ContentView().loadFormJSONToData() else { return }

        // Test validate function with some mock data
        let formModel = FormModel(from: jsonData)
        XCTAssertTrue(formModel.validate())
    }

    func testApplyBusinessRules() {
        guard let jsonData = ContentView().loadFormJSONToData() else { return }

        // Test applying business rules
        let formModel = FormModel(from: jsonData)

        // Assuming there are no rules to apply initially
        formModel.applyBusinessRules()

        // If there were rules, we could test conditions being met or not met
    }

    func testEvaluateCondition() {
        guard let jsonData = ContentView().loadFormJSONToData() else { return }

        // Example of testing the evaluation of a condition
        let formModel = FormModel(from: jsonData)

        let rule = Rule(condition: Condition(type: .string, value: AnyCodable("John Doe"), dependsOn: nil, conditionOperator: .equalTo), actions: [])
        let isValid = formModel.evaluateCondition(rule, dependentValue: "John Doe", field: formModel.fields[0])

        XCTAssertTrue(isValid)
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
            self.testFormModelParsing()
        }
    }

    override class func setUp() {

    }

}
