import XCTest
@testable import yacss

class appSettingsTests: XCTestCase {
    var appSettings:AppSettings? = nil
    let nilKey = "nonExistentPreference"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.appSettings = AppSettings()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetPreferenceArrayOfWaypointsNil(){
        let nilValue:[Waypoint]? = appSettings!.getPreference(forKey: self.nilKey)
        XCTAssertNil(nilValue)
    }
    
    func testGetPreferenceArrayOfMilestonesNil(){
        let nilValue:[Milestone]? = appSettings!.getPreference(forKey: self.nilKey)
        XCTAssertNil(nilValue)
    }
    
    func testGetPreferenceNSColorNil(){
        let nilValue:NSColor? = appSettings!.getPreference(forKey: self.nilKey)
        XCTAssertNil(nilValue)
    }
    
    func testGetPreferenceDistionaryOfAnyNil(){
        let nilValue:[[String: Any?]]? = appSettings?.getPreference(forKey: self.nilKey)
        XCTAssertNil(nilValue)
    }
    
    
}
