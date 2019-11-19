import Foundation
import Cocoa

class AppSettings{
    private(set) public var defaultPreferenceValues: [String: Any] = [
        PlistKey.configuringMessage.rawValue: "Configuring...",
        PlistKey.doNotTurnOffMessage.rawValue: "Do not shut off or disconnect the deivce.",
        PlistKey.completedMessage.rawValue: "Configured.",
    
        PlistKey.fullScreenConfigurationMode.rawValue: false,
        PlistKey.exitOnConfigurationComplete.rawValue: false,
    
        PlistKey.loglineTimestampDelimiter.rawValue: "]",
        PlistKey.loglineTimestampDelimiterOffset.rawValue: 3,
        PlistKey.logFileEncoding.rawValue: String.Encoding.utf8.rawValue,
    
        PlistKey.configuringContentUrl.rawValue: "/Users/mzanoski/source/maza.io/yams/configuring.html",
    
        PlistKey.greetingMessage.rawValue: "Welcome %@!",
        
        PlistKey.configuringWindowLevel.rawValue: Int(CGWindowLevelForKey(.floatingWindow)),
        
        "theme": [
            "colors": [
                PlistKey.windowBackgroundColor.rawValue: NSColor(hexString: "0xECECEC"),
                PlistKey.greetingColor.rawValue: NSColor(hexString: "0x1B1B1B"),
                PlistKey.statusColor.rawValue: NSColor(hexString: "0x808080"),
                PlistKey.loglineColor.rawValue: NSColor(hexString: "0xBABABA"),
                PlistKey.milestonePendingTintColor.rawValue: NSColor.controlBackgroundColor,
                PlistKey.milestoneReachedTintColor.rawValue: NSColor.alternateSelectedControlColor,
            ],
        ]
    ]
    
    init(){
        // set default values first if they don't already exist in plist
        for key in defaultPreferenceValues.keys {
            if key == "theme" {
                // colors
                let colorsDictionary = (defaultPreferenceValues["theme"] as! [String: Any?])["colors"] as! [String: Any?]
                for subKey in colorsDictionary.keys{
                    saveDefaultPreferenceIfNotSet(forKey: subKey, color: colorsDictionary[subKey] as! NSColor)
                }
                continue;
            }
            saveDefaultPreferenceIfNotSet(forKey: key, value: defaultPreferenceValues[key] as Any)
        }
    }
    
    private func saveDefaultPreferenceIfNotSet(forKey: String, value: Any){
        if let _ = CFPreferencesCopyAppValue(forKey as CFString, kCFPreferencesCurrentApplication) {
            // value for this key is already set, nothing to do
            return
        }
        // TODO: convert Any value to actual type
        if let typedValue = value as? String {
            saveDefaultPreferenceIfNotSet(forKey: forKey, value: typedValue)
        }
        if let typedValue = value as? Int {
            saveDefaultPreferenceIfNotSet(forKey: forKey, value: typedValue)
        }
        if let typedValue = value as? Float {
            saveDefaultPreferenceIfNotSet(forKey: forKey, value: typedValue)
        }
        if let typedValue = value as? Bool {
            saveDefaultPreferenceIfNotSet(forKey: forKey, value: typedValue)
        }
    }
    
    private func saveDefaultPreferenceIfNotSet(forKey: String, value: String){
        CFPreferencesSetAppValue(forKey as CFString, value as CFString, kCFPreferencesCurrentApplication)
    }
    
    private func saveDefaultPreferenceIfNotSet(forKey: String, value: Int){
        CFPreferencesSetAppValue(forKey as CFString, value as CFNumber, kCFPreferencesCurrentApplication)
    }
    
    private func saveDefaultPreferenceIfNotSet(forKey: String, value: Float){
        CFPreferencesSetAppValue(forKey as CFString, value as CFNumber, kCFPreferencesCurrentApplication)
    }
    
    private func saveDefaultPreferenceIfNotSet(forKey: String, value: Bool){
        CFPreferencesSetAppValue(forKey as CFString, value as CFBoolean, kCFPreferencesCurrentApplication)
    }
    
    
    private func saveDefaultPreferenceIfNotSet(forKey: String, color: NSColor){
        if let _:String = getPreference(forKey: forKey) {
            // value for this key is already set, nothing to do
            return
        }

        if let rgbColor = color.rgbHexColorStringNoAlpha{
            CFPreferencesSetAppValue(forKey as CFString, rgbColor as CFString, kCFPreferencesCurrentApplication)
        }
    }
    
    public func getPreference(forKey: String) -> Bool {
        guard let boolValue = CFPreferencesCopyAppValue(forKey as CFString, kCFPreferencesCurrentApplication) as? Bool else {
            return false
        }
        return boolValue
    }
    
    public func getPreference(forKey: String) -> Int?{
        return CFPreferencesCopyAppValue(forKey as CFString, kCFPreferencesCurrentApplication) as? Int
    }
    
    public func getPreference(forKey: String) -> String.Encoding?{
        guard let intValue:Int = getPreference(forKey: forKey) else {
            return nil
        }
        return String.Encoding(rawValue: UInt(intValue))
    }
    
    public func getPreference(forKey: String) -> String?{
        return CFPreferencesCopyAppValue(forKey as CFString, kCFPreferencesCurrentApplication) as? String
    }
    
    public func getPreference(forKey: String) -> Character?{
        guard let stringValue:String = getPreference(forKey: forKey) else {
            return nil
        }
        
        if stringValue.characters.count == 0 {
            return nil
        }
        
        return stringValue.characters[stringValue.startIndex]
    }
    
    public func getPreference(forKey: String) -> NSColor? {
        guard let stringValue:String = getPreference(forKey: forKey) else {
            return nil
        }
        return NSColor(hexString: stringValue)
    }
    
    public func getPreference(forKey: String) -> [[String: Any?]]?{
        guard let rawArray = CFPreferencesCopyAppValue(forKey as CFString, kCFPreferencesCurrentApplication) as? NSArray else {
            return nil
        }
        var dictionaryArray = Array<Dictionary<String, Any?>>()
        
        for item in rawArray {
            dictionaryArray.append(item as! [String: Any?])
        }
        return dictionaryArray
    }
    
    public func getPreference(forKey: String) -> Array<Waypoint>?{
        guard let rawArray = CFPreferencesCopyAppValue(forKey as CFString, kCFPreferencesCurrentApplication) as? NSArray else {
            return nil
        }

        var waypoints = Array<Waypoint>()
        
        for item in rawArray {
            let rawItem = item as! [String: Any?]
            
            if let command: String = rawItem[PlistKey.waypointVerifyCommand.rawValue] as? String,
                let waypointIndex: Int = rawItem[PlistKey.waypointIndex.rawValue] as? Int {
                waypoints.append(Waypoint(checkCommand: command, index: waypointIndex))
            }
        }
        return waypoints
    }
    
    public func getPreference(forKey: String) -> Array<Milestone>?{
        guard let rawArray = CFPreferencesCopyAppValue(forKey as CFString, kCFPreferencesCurrentApplication) as? NSArray else {
            return nil
        }

        var waypoints = Array<Milestone>()
        
        for item in rawArray {
            let rawItem = item as! [String: Any?]
            
            if let atWaypointIndex = rawItem[PlistKey.atWaypointIndex.rawValue] as? Int, let imagePath: String = rawItem[PlistKey.imagePath.rawValue] as? String{
                let completedImagePath = rawItem[PlistKey.completedImagePath.rawValue] as? String
                waypoints.append(Milestone(atWaypointIndex: atWaypointIndex, imagePath: imagePath, completedImagePath: completedImagePath))
            }
        }
        return waypoints
    }
}


