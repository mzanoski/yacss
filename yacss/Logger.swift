import Foundation
import Cocoa

class Logger {
    private let logFilePath: String
    private let logStream: OutputStream
    private(set) public var logLevel: Int
    
    init(directory: String, logLevel: Int = 1){
        self.logLevel = logLevel
        if directory.characters.last == "/" {
            self.logFilePath = "\(directory)\(ProcessInfo.processInfo.processName).log"
        }
        else{
            self.logFilePath = "\(directory)/\(ProcessInfo.processInfo.processName).log"
        }
        
        if !FileManager.default.fileExists(atPath: self.logFilePath) {
            FileManager.default.createFile(atPath: self.logFilePath, contents: nil, attributes: nil)
        }
        
        // open log file stream
        logStream = OutputStream(toFileAtPath: self.logFilePath, append: true)!
        logStream.open()
    }
    
    deinit {
        logStream.close()
    }
    
    private func writeToFile(line: String, messageLogLevel: Int){
        if self.logLevel >= messageLogLevel {
            let timestamp = Date().logFormat
            let logline = "\(timestamp) \(line)\n"
            logStream.write(logline, maxLength: logline.lengthOfBytes(using: String.Encoding.utf8))
        }
    }
    
    public func error(message: String){
        writeToFile(line: "[Error]: \(message)", messageLogLevel: LogLevel.Error.rawValue)
    }
    
    public func warn(message: String){
        writeToFile(line: "[Warn]: \(message)", messageLogLevel: LogLevel.Warn.rawValue)
    }
    
    public func info(message: String){
        writeToFile(line: "[Info]: \(message)", messageLogLevel: LogLevel.Info.rawValue)
    }
    
    public func debug(message: String){
        writeToFile(line: "[Debug]: \(message)", messageLogLevel: LogLevel.Debug.rawValue)
    }
    
    public func trace(message: String){
        writeToFile(line: "[Trace]: \(message)", messageLogLevel: LogLevel.Trace.rawValue)
    }
    
    public func setLogTo(level: Int?){
        if let newLogLevel = level{
            self.logLevel = newLogLevel
        }
    }
}
