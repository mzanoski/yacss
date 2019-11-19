import Foundation
import Cocoa

class Milestone {
    private var pendingImagePath: String
    private var completedImagePath: String? = nil
    private(set) public var atWaypointIndex: Int
    public weak var view: NSImageView? = nil
    public var reached: Bool = false
    
    init(atWaypointIndex: Int, imagePath: String){
        self.atWaypointIndex = atWaypointIndex
        self.pendingImagePath = imagePath
    }
    
    init(atWaypointIndex: Int, imagePath: String, completedImagePath: String?){
        self.atWaypointIndex = atWaypointIndex
        self.pendingImagePath = imagePath
        self.completedImagePath = completedImagePath
    }
    
    public func getImagePath() -> String{
        var imagePath = self.pendingImagePath
        
        if reached && self.completedImagePath != nil {
            imagePath = self.completedImagePath!
        }
        return imagePath
    }
}
