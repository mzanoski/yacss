import Foundation
import Cocoa


func getFileHandle(filePath: String) -> FileHandle? {
    return FileHandle(forReadingAtPath: filePath)
}

// if the current waypoint has been hit, then remove it from the list and get next one.  If it hasn't been hit, current waypoint is the next waypoint (i.e. no change)
func getNextWaypoint(waypoints: [Waypoint]?) -> (remainingWaypoints: [Waypoint]?, currentWaypoint: Waypoint?){
    guard waypoints != nil else {
        return (nil, nil)
    }
    
    guard waypoints!.count > 0 else {
        return (nil, nil)
    }
    
    // there has to be at least one item in the list at this point so it's safe to force-unwrap it. what guards are for
    // get waypoint with lowest index value (i.e. next in line)
    let currentWaypoint = waypoints!.minWaypoint!
    
    if currentWaypoint.check() {
        // if verification passed, get index of lowest item and remove it
        let remainingWaypoints = waypoints!.removeWaypoint(item: currentWaypoint)
        return (remainingWaypoints, currentWaypoint)
    }
    return (waypoints, nil)
}

func readLastLogLine(fileHandle: FileHandle?) -> String? {
    // either we do all this here or we have to string all these params into every function all the way up the chain
    var logLineTimestampDelimiter:Character = "\n"
    var logLineTimestampDelimiterOffset = 0
    var encoding = String.Encoding.utf8
    var chunkSize = 256
    
    let appSettings = (NSApplication.shared().delegate as! AppDelegate).appSettings
    
    if let delim:Character = appSettings.getPreference(forKey: PlistKey.loglineTimestampDelimiter.rawValue) {
        logLineTimestampDelimiter = delim
    }
    
    if let off:Int = appSettings.getPreference(forKey: PlistKey.loglineTimestampDelimiterOffset.rawValue){
        logLineTimestampDelimiterOffset = off
    }
    
    if let enc:String.Encoding = appSettings.getPreference(forKey: PlistKey.logFileEncoding.rawValue){
        encoding = enc
    }
    
    if let cs:Int = appSettings.getPreference(forKey: PlistKey.logFileChunkSize.rawValue){
        chunkSize = cs
    }
    
    if let handle = fileHandle, let logLine = readLastLineInTextFile(fileHandle: handle, encoding: encoding, chunkSize: chunkSize) {
        return removeTimestampFromLogLine(
            textLine: logLine,
            delimiter: logLineTimestampDelimiter,
            offset: logLineTimestampDelimiterOffset
        )
    }
    return nil
}

func readLastLineInTextFile(fileHandle: FileHandle, delimiter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 256) -> String?{
    var lastLine: String?
    var buffer = Data(capacity: chunkSize)
    var endOfFile = false
    // go to end of file and grab only a little data near the end
    var seekToOffset = UInt64(0)
    let eofOffset = fileHandle.seekToEndOfFile()
    
    if eofOffset > UInt64(chunkSize) {
        seekToOffset = eofOffset - UInt64(chunkSize)
    }
    fileHandle.seek(toFileOffset: seekToOffset)
    
    while !endOfFile {
        let tmpData = fileHandle.readData(ofLength: chunkSize)
        if tmpData.count > 0 {
            buffer.append(tmpData)
        } else {
            // EOF or read error.
            endOfFile = true
            if buffer.count > 0 {
                let contents = String(data: buffer, encoding: encoding)
                var lines = contents!.components(separatedBy: delimiter)
                // remove empty last line if it exists
                while let delimIndex = lines.index(of: ""){
                    lines.remove(at: delimIndex)
                }
                
                if lines.count > 0 {
                    lastLine = lines[lines.endIndex-1]
                }
            }
        }
    }
    return lastLine
}

func removeTimestampFromLogLine(textLine: String, delimiter: Character = " ", offset: Int = 0) -> String? {
    if let delimiterIndex = textLine.characters.index(of: delimiter){
        if let messageIndex = textLine.index(delimiterIndex, offsetBy: offset, limitedBy: textLine.endIndex) {
            return textLine.substring(from: messageIndex)
        }
    }
    return nil
}
