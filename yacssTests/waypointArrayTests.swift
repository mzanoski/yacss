import XCTest
@testable import yacss

class waypointArrayTests: XCTestCase {
    var waypointArray:[Waypoint]? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let wp0 = Waypoint(checkCommand: "", index: 0)
        let wp1 = Waypoint(checkCommand: "", index: 1)
        let wp2 = Waypoint(checkCommand: "", index: 2)
        let wp3 = Waypoint(checkCommand: "", index: 3)
        
        waypointArray = [wp0, wp1, wp2, wp3]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRemoveWaypointExisting(){
        let originalWaypointCount = self.waypointArray?.count
        let toBeRemovedWaypointExisting = Waypoint(checkCommand: "", index: 0)
        let removedWaypointArray = self.waypointArray?.removeWaypoint(item: toBeRemovedWaypointExisting)
        let nextWaypoint = removedWaypointArray?.minWaypoint
        
        XCTAssertTrue(removedWaypointArray!.count == originalWaypointCount! - 1)
        XCTAssertTrue(nextWaypoint!.index == 1)
    }
    
    func testRemoveWaypointNonExisting(){
        let originalWaypointCount = self.waypointArray?.count
        let toBeRemovedWaypointNonExisting = Waypoint(checkCommand: "", index: 110)
        
        let nonRemovedItemWaypointArray = self.waypointArray?.removeWaypoint(item: toBeRemovedWaypointNonExisting)
        XCTAssertTrue(nonRemovedItemWaypointArray!.count == originalWaypointCount!)
    }
    
    func testRemoveWaypointEmptyArray(){
        let emptyWaypointArray = Array<Waypoint>()
        let toBeRemovedWaypoint = Waypoint(checkCommand: "", index: 0)
        
        let removedItemEmptyWaypointArray = emptyWaypointArray.removeWaypoint(item: toBeRemovedWaypoint)
        XCTAssertTrue(removedItemEmptyWaypointArray.count == 0)
    }
    
    func testMinWaypoint(){
        let minWaypoint0 = self.waypointArray?.minWaypoint
        self.waypointArray = self.waypointArray?.removeWaypoint(item: minWaypoint0!)
        XCTAssertTrue(minWaypoint0?.index == 0)
        
        let minWaypoint1 = self.waypointArray?.minWaypoint
        self.waypointArray = self.waypointArray?.removeWaypoint(item: minWaypoint1!)
        XCTAssertTrue(minWaypoint1?.index == 1)
        
        let minWaypoint2 = self.waypointArray?.minWaypoint
        self.waypointArray = self.waypointArray?.removeWaypoint(item: minWaypoint2!)
        XCTAssertTrue(minWaypoint2?.index == 2)
        
        let minWaypoint3 = self.waypointArray?.minWaypoint
        self.waypointArray = self.waypointArray?.removeWaypoint(item: minWaypoint3!)
        XCTAssertTrue(minWaypoint3?.index == 3)
    }
    
    func testMinWaypointEmptyArray(){
        let emptyWaypointArray = Array<Waypoint>()
        let minWaypointNil = emptyWaypointArray.minWaypoint
        XCTAssertNil(minWaypointNil)
    }
    
    func testMaxWaypoit(){
        let maxWaypoint3 = self.waypointArray?.maxWaypoint
        self.waypointArray = self.waypointArray?.removeWaypoint(item: maxWaypoint3!)
        XCTAssertTrue(maxWaypoint3?.index == 3)
        
        let maxWaypoint2 = self.waypointArray?.maxWaypoint
        self.waypointArray = self.waypointArray?.removeWaypoint(item: maxWaypoint2!)
        XCTAssertTrue(maxWaypoint2?.index == 2)
        
        let maxWaypoint1 = self.waypointArray?.maxWaypoint
        self.waypointArray = self.waypointArray?.removeWaypoint(item: maxWaypoint1!)
        XCTAssertTrue(maxWaypoint1?.index == 1)
        
        let maxWaypoint0 = self.waypointArray?.maxWaypoint
        self.waypointArray = self.waypointArray?.removeWaypoint(item: maxWaypoint0!)
        XCTAssertTrue(maxWaypoint0?.index == 0)
    }
    
    func testMaxWaypointEmptyArray(){
        let emptyWaypointArray = Array<Waypoint>()
        let maxWaypointNil = emptyWaypointArray.maxWaypoint
        XCTAssertNil(maxWaypointNil)
    }
}
