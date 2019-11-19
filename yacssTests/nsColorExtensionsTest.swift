import XCTest
@testable import yacss

class nsColorExtensionsTest: XCTestCase {
    let validHexColorString = "ababab"
    let validHexColorString_0x = "0xbcbcbc"
    let validHexColorString_00 = "ababab00"
    let validHexColorString_zz = "abbczz"
    
    let nonRGBColor = NSColor.windowBackgroundColor
    
    let invalidHexColorString = "#ababab"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidHexStringInit(){
        let color1 = NSColor(hexString: self.validHexColorString)
        let color2 = NSColor(hexString: self.validHexColorString_0x)
        let color3 = NSColor(hexString: self.validHexColorString_00)
        let color4 = NSColor(hexString: self.validHexColorString_zz)
        
        XCTAssertNotNil(color1)
        XCTAssertNotNil(color2)
        XCTAssertNotNil(color3)
        XCTAssertNotNil(color4)
    }
    
    func testInvalidHexStringInit(){
        let color1 = NSColor(hexString: self.invalidHexColorString)
        XCTAssertNil(color1)
    }
    
    func testHexColorStringNoAlpha(){
        let color1 = NSColor(hexString: self.validHexColorString)
        let color2 = NSColor(hexString: self.validHexColorString_0x)
        let color3 = NSColor(hexString: self.validHexColorString_00)
        let color4 = NSColor(hexString: self.validHexColorString_zz)
        
        XCTAssertTrue(color1?.rgbHexColorStringNoAlpha?.lowercased() == self.validHexColorString)
        XCTAssertTrue(color2?.rgbHexColorStringNoAlpha?.lowercased() == "bcbcbc")
        XCTAssertTrue(color3?.rgbHexColorStringNoAlpha?.lowercased() == "abab00")
        XCTAssertTrue(color4?.rgbHexColorStringNoAlpha?.lowercased() == "00abbc")    
    }
    
    func testHexColorStringNoAlphaNonRGBColor(){
        XCTAssertNil(self.nonRGBColor.rgbHexColorStringNoAlpha)
    }
}
