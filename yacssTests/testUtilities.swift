import XCTest
@testable import yacss

class testUtilities: XCTestCase {
    let emptyWaypoints = Array<Waypoint>()
    let nilWaypoints:[Waypoint]? = nil
    var waypoints:[Waypoint]? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let wp0 = Waypoint(checkCommand: "echo 1", index: 0)
        let wp1 = Waypoint(checkCommand: "echo x", index: 1)
        waypoints = [wp0, wp1] //, wp2, wp3
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetNextWaypointFromNilArray(){
        let result = getNextWaypoint(waypoints: self.nilWaypoints)
        
        XCTAssertNil(result.currentWaypoint)
        XCTAssertNil(result.remainingWaypoints)
    }
    
    func testGetNextWaypointFromEmptyArray(){
        let result = getNextWaypoint(waypoints: self.emptyWaypoints)
        
        XCTAssertNil(result.currentWaypoint)
        XCTAssertNil(result.remainingWaypoints)
    }
    
    func testGetNextWaypointCheckPassed(){
        let result = getNextWaypoint(waypoints: self.waypoints)
        
        XCTAssertTrue(result.currentWaypoint?.index == 0)
        XCTAssertTrue(result.remainingWaypoints?.count == 1)
    }
    
    func testGetNextWaypointCheckFailed(){
        let r1 = getNextWaypoint(waypoints: self.waypoints)
        let remainingWaypoints = r1.remainingWaypoints
        let result = getNextWaypoint(waypoints: remainingWaypoints)
        
        XCTAssertTrue(result.remainingWaypoints?.count == 1)
        XCTAssertNil(result.currentWaypoint)
    }
}
