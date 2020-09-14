import XCTest
@testable import ZKUtil

final class ZKUtilTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ZKUtil().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
