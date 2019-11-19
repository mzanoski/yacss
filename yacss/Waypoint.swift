import Foundation

class Waypoint{
    private(set) public var checkCommand: String
    private(set) public var index: Int
    
    init(checkCommand: String, index: Int){
        self.checkCommand = checkCommand
        self.index = index
    }
    
    public func check() -> Bool {
        let result = ShellCommand.execute(command: self.checkCommand)
        
        if let output = result.output{
            return output.boolValue
        }
        return false
    }
}
