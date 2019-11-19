import XCTest
@testable import yacss

class milestoneArrayTests: XCTestCase {
    var milestoneArray:[Milestone]? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let ms0 = Milestone(atWaypointIndex: 0, imagePath: "")
        ms0.reached = false
        let ms1 = Milestone(atWaypointIndex: 1, imagePath: "")
        ms1.reached = true
        let ms2 = Milestone(atWaypointIndex: 2, imagePath: "")
        ms2.reached = false
        let ms3 = Milestone(atWaypointIndex: 3, imagePath: "")
        
        milestoneArray = [ms0, ms1, ms2, ms3]
    }
    
    func testRemoveMilestoneExisting(){
        let originalMilestoneCount = self.milestoneArray?.count
        let toBeRemovedMilestoneExisting = Milestone(atWaypointIndex: 0, imagePath: "")
        let removedMilestoneArray = self.milestoneArray?.removeMilestone(item: toBeRemovedMilestoneExisting)
        let nextMilestone = removedMilestoneArray?.minMilestone
        
        XCTAssertTrue(removedMilestoneArray!.count == originalMilestoneCount! - 1)
        XCTAssertTrue(nextMilestone!.atWaypointIndex == 1)
    }
    
    func testRemoveMilestoneNonExisting(){
        let originalMilestoneCount = self.milestoneArray?.count
        let toBeRemovedMilestoneNonExisting = Milestone(atWaypointIndex: 100, imagePath: "")
        
        let nonRemovedItemMilestoneArray = self.milestoneArray?.removeMilestone(item: toBeRemovedMilestoneNonExisting)
        XCTAssertTrue(nonRemovedItemMilestoneArray!.count == originalMilestoneCount!)
    }
    
    func testRemoveMilestoneEmptyArray(){
        let emptyMilestoneArray = Array<Milestone>()
        let toBeRemovedMilestone = Milestone(atWaypointIndex: 0, imagePath: "")
        
        let removedItemEmptyMilestoneArray = emptyMilestoneArray.removeMilestone(item: toBeRemovedMilestone)
        XCTAssertTrue(removedItemEmptyMilestoneArray.count == 0)
    }
    
    func testMinMilestone(){
        let minMilestone0 = self.milestoneArray?.minMilestone
        self.milestoneArray = self.milestoneArray?.removeMilestone(item: minMilestone0!)
        XCTAssertTrue(minMilestone0?.atWaypointIndex == 0)
        
        let minMilestone1 = self.milestoneArray?.minMilestone
        self.milestoneArray = self.milestoneArray?.removeMilestone(item: minMilestone1!)
        XCTAssertTrue(minMilestone1?.atWaypointIndex == 1)
        
        let minMilestone2 = self.milestoneArray?.minMilestone
        self.milestoneArray = self.milestoneArray?.removeMilestone(item: minMilestone2!)
        XCTAssertTrue(minMilestone2?.atWaypointIndex == 2)
        
        let minMilestone3 = self.milestoneArray?.minMilestone
        self.milestoneArray = self.milestoneArray?.removeMilestone(item: minMilestone3!)
        XCTAssertTrue(minMilestone3?.atWaypointIndex == 3)
    }
    
    func testMinMilestoneEmptyArray(){
        let emptyMilestoneArray = Array<Milestone>()
        let minMilestoneNil = emptyMilestoneArray.minMilestone
        XCTAssertNil(minMilestoneNil)
    }
    
    func testNextPendingMilestone(){
        let nextPendingMilestone = self.milestoneArray?.nextPendingMilestone
        XCTAssertTrue(nextPendingMilestone?.atWaypointIndex == 0)
        
        nextPendingMilestone?.reached = true
        let anotherPendingMilestone = self.milestoneArray?.nextPendingMilestone
        XCTAssertTrue(anotherPendingMilestone?.atWaypointIndex == 2)
    }
    
    func testSortedByWaypointIndex(){
        let sortedMilestoneArray = self.milestoneArray?.sortedByWaypointIndex
        let milestone0 = sortedMilestoneArray?[0]
        let milestone1 = sortedMilestoneArray?[1]
        let milestone2 = sortedMilestoneArray?[2]
        let milestone3 = sortedMilestoneArray?[3]
        
        XCTAssertTrue(milestone0?.atWaypointIndex == 0)
        XCTAssertTrue(milestone1?.atWaypointIndex == 1)
        XCTAssertTrue(milestone2?.atWaypointIndex == 2)
        XCTAssertTrue(milestone3?.atWaypointIndex == 3)
    }
    
    func testIndex(){
        let milestoneAtIndex0 = Milestone(atWaypointIndex: 0, imagePath: "")
        let milestoneAtIndex2 = Milestone(atWaypointIndex: 2, imagePath: "")
        
        XCTAssertTrue(self.milestoneArray?.index(of: milestoneAtIndex0) == 0)
        XCTAssertTrue(self.milestoneArray?.index(of: milestoneAtIndex2) == 2)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
