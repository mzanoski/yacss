import XCTest
@testable import yacss

class waypointTests: XCTestCase {
    let reachedWaypoint = Waypoint(checkCommand: "echo 1", index: 0)
    let pendingWaypoint = Waypoint(checkCommand: "echo z", index: 0)
    let errorCommandWaypoint = Waypoint(checkCommand: "foobar 1&>/dev/null", index: 0)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReachedWaypoint(){
        XCTAssertTrue(reachedWaypoint.check())
    }
    
    func testPendingMilestone(){
        XCTAssertFalse(pendingWaypoint.check())
    }
    
    func testErroredCommandWaypoint(){
        XCTAssertFalse(self.errorCommandWaypoint.check())
    }
}
