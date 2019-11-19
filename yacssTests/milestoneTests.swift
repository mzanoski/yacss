import XCTest
@testable import yacss

class milestoneTests: XCTestCase {
    let pendingImagePath = "pending"
    let completedImagePath = "completed"
    var pendingImageMilestone:Milestone? = nil
    var completedImageMilestone:Milestone? = nil
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        pendingImageMilestone = Milestone(atWaypointIndex: 0, imagePath: pendingImagePath)
        completedImageMilestone = Milestone(atWaypointIndex: 0, imagePath: pendingImagePath, completedImagePath: completedImagePath)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPendingImage(){
        XCTAssertTrue(self.pendingImageMilestone?.getImagePath() == self.pendingImagePath)
        XCTAssertTrue(self.completedImageMilestone?.getImagePath() == self.pendingImagePath)
    }
    
    func testCompletedImage(){
        self.pendingImageMilestone?.reached = true
        XCTAssertTrue(self.pendingImageMilestone?.getImagePath() == self.pendingImagePath)
        
        self.completedImageMilestone?.reached = true
        XCTAssertTrue(self.completedImageMilestone?.getImagePath() == self.completedImagePath)
    }
}
