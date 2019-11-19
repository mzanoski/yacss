import Foundation
import Cocoa

class LicenseWindowController: NSWindowController {
    @IBOutlet weak var licenseView: NSScrollView!
    @IBOutlet var licenseTextView: NSTextView!
    @IBOutlet weak var view: NSView!
    
    override init(window: NSWindow?){
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func windowDidLoad() {
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.isMovableByWindowBackground = true
        self.view.window?.backgroundColor = NSColor.white
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        if let licenseText = loadFileFromBundle(fileName: "license", type: "txt"){
            self.licenseTextView.string = licenseText
        }
    }
    
    func loadFileFromBundle(fileName: String, type: String) -> String?{
        if let filePath = Bundle.main.path(forResource: fileName, ofType: type){
            if FileManager.default.fileExists(atPath: filePath){
                let contents = FileManager.default.contents(atPath: filePath)
                return String(data: contents!, encoding: String.Encoding.utf8)
            }
        }
        return nil
    }
}
