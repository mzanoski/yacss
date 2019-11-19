import XCTest
@testable import yacss


class stringExtensionsTests: XCTestCase {
    // true strings chars
    let boolStringTrue_Y = "Y"
    let boolStringTrue_y = "y"
    let boolStringTrue_T = "T"
    let boolStringTrue_t = "t"
    
    let boolStringTrue_yes = "yes"
    let boolStringTrue_true = "true"
    
    // true strings digits
    let boolStringTrue_1 = "1"
    let boolStringTrue_2 = "2"
    let boolStringTrue_3 = "3"
    let boolStringTrue_4 = "4"
    let boolStringTrue_5 = "5"
    let boolStringTrue_6 = "6"
    let boolStringTrue_7 = "7"
    let boolStringTrue_8 = "8"
    let boolStringTrue_9 = "9"
    
    let boolStringTrue_10 = "10"
    
    // false strings chars
    let boolStringFalse_empty = ""
    let boolStringFalse_no = "no"
    let boolStringFalse_false = "false"
    // false strings digits
    let boolStringFalse_0 = "0"
    let boolStringFalse_a100 = "a100"
    let boolStringFalse_atrue10 = "atrue10"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBoolTrueValues(){
        XCTAssertTrue(self.boolStringTrue_y.boolValue)
        XCTAssertTrue(self.boolStringTrue_Y.boolValue)
        XCTAssertTrue(self.boolStringTrue_T.boolValue)
        XCTAssertTrue(self.boolStringTrue_t.boolValue)
        
        XCTAssertTrue(self.boolStringTrue_yes.boolValue)
        XCTAssertTrue(self.boolStringTrue_true.boolValue)
        
        XCTAssertTrue(self.boolStringTrue_1.boolValue)
        XCTAssertTrue(self.boolStringTrue_2.boolValue)
        XCTAssertTrue(self.boolStringTrue_3.boolValue)
        XCTAssertTrue(self.boolStringTrue_4.boolValue)
        XCTAssertTrue(self.boolStringTrue_5.boolValue)
        XCTAssertTrue(self.boolStringTrue_6.boolValue)
        XCTAssertTrue(self.boolStringTrue_7.boolValue)
        XCTAssertTrue(self.boolStringTrue_8.boolValue)
        XCTAssertTrue(self.boolStringTrue_9.boolValue)
        
        XCTAssertTrue(self.boolStringTrue_10.boolValue)
    }
    
    func testBoolFalseValues(){
        XCTAssertFalse(self.boolStringFalse_empty.boolValue)
        XCTAssertFalse(self.boolStringFalse_no.boolValue)
        XCTAssertFalse(self.boolStringFalse_false.boolValue)
        XCTAssertFalse(self.boolStringFalse_0.boolValue)
        
        XCTAssertFalse(self.boolStringFalse_a100.boolValue)
        XCTAssertFalse(self.boolStringFalse_atrue10.boolValue)
    }
}
