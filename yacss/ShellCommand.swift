import Foundation

import Cocoa

class ShellCommand: NSObject {
    static func execute(command: String) -> (output: String?, exitCode: Int32, error: String?){
        var output: String?
        var error: String?
        
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        
        let stdOutPipe = Pipe()
        task.standardOutput = stdOutPipe
        
        let stdErrPipe = Pipe()
        task.standardError = stdErrPipe
        
        task.launch()
        task.waitUntilExit()
        
        let stdOutData = stdOutPipe.fileHandleForReading.readDataToEndOfFile()
        if let outData = NSString(data: stdOutData, encoding: String.Encoding.utf8.rawValue) {
            let tmpOutput = (outData as String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if !tmpOutput.isEmpty{
                output = tmpOutput
            }
        }
        
        let stdErrData = stdErrPipe.fileHandleForReading.readDataToEndOfFile()
        if let errData = NSString(data: stdErrData, encoding: String.Encoding.utf8.rawValue){
            error = (errData as String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        let exitCode = task.terminationStatus
        return (output, exitCode, error)
    }
}
