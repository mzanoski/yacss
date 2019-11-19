import Foundation
import Cocoa

//let logger = (NSApplication.shared().delegate as! AppDelegate).logger

extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
}

extension Array where Element: Waypoint {
    var minWaypoint: Waypoint? {
        return self.min(by: { (a, b) -> Bool in
            return b.index > a.index
        })
    }
    
    var maxWaypoint: Waypoint? {
        return self.max(by: { (a, b) -> Bool in
            return b.index > a.index
        })
    }
    
    func removeWaypoint(item: Waypoint) -> [Waypoint] {
        var newSelf = self
        let itemIndex = self.index(where: { (current) -> Bool in current.index == item.index})
        
        if let index = itemIndex{
            newSelf.remove(at: index)
        }
        return newSelf
    }
}

extension Array where Element: Milestone {
    var minMilestone: Milestone? {
        return self.min(by: { (a, b) -> Bool in
            return b.atWaypointIndex > a.atWaypointIndex
        })
    }
    
    var sortedByWaypointIndex: [Milestone]{
        return self.sorted(by: {(a, b) -> Bool in
            return b.atWaypointIndex > a.atWaypointIndex
        })
    }
    
    var nextPendingMilestone: Milestone?{
        let pending = self.filter({
            !$0.reached
        })
        
        return pending.minMilestone
    }
    
    func removeMilestone(item: Milestone) -> [Milestone] {
        var newSelf = self
        let itemIndex = self.index(where: { (current) -> Bool in current.atWaypointIndex == item.atWaypointIndex})
        if let index = itemIndex{
            newSelf.remove(at: index)
        }
        return newSelf
    }
    
    func index(of: Milestone) -> Int?{
        let index = self.index(where: { (item) -> Bool in
            item.atWaypointIndex == of.atWaypointIndex
        })
        return index
    }
}

extension Date {
    struct Formatter {
        static let logFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter
        }()
    }
    var logFormat: String {
        return Formatter.logFormat.string(from: self)
    }
}

extension NSImage {
    func setTint(toColor: NSColor?) -> NSImage{
        guard let tintColor = toColor else {
            return self
        }
        
        let tintedImage = self.copy() as! NSImage
        
        tintedImage.lockFocus()
        tintColor.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: self.size)
        NSRectFillUsingOperation(imageRect, .sourceAtop)
        
        tintedImage.unlockFocus()
        tintedImage.isTemplate = false
        return tintedImage
    }
}

extension NSColor {
    convenience init?(hexString: String){
        let scanner = Scanner(string: hexString)
        var value: UInt64 = 0
        
        if scanner.scanHexInt64(&value) {
            let r = Float((value >> 16) & 0xFF) / 255.0
            let g = Float((value >> 8) & 0xFF) / 255.0
            let b = Float((value) & 0xFF) / 255.0
            
            self.init(
                colorLiteralRed: r,
                green: g,
                blue: b,
                alpha: 1.0
            )
        }
        else{
            return nil
        }
    }
    
    var rgbHexColorStringNoAlpha: String? {
        if let color = self.usingColorSpace(.sRGB){
            let r: CGFloat = color.redComponent
            let g: CGFloat = color.greenComponent
            let b: CGFloat = color.blueComponent
            
            let hexString = String(format:"%02X%02X%02X", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff))
            return hexString
        }
        return nil
    }
}
