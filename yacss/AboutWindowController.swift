import Foundation
import Cocoa

class AboutWindowController: NSWindowController{
    @IBOutlet weak var appIconView: NSImageView!
    @IBOutlet weak var appName: NSTextField!
    @IBOutlet weak var appVersion: NSTextField!
    @IBOutlet weak var copyright: NSTextField!
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var byDeveloper: NSTextField!
    var licenseController: LicenseWindowController? = nil
    
    override init(window: NSWindow?){
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func windowDidLoad() {
        setWindowLook()
        
        let infoDictionary = Bundle.main.infoDictionary! as [String: Any]
        let appName = infoDictionary["CFBundleName"] as! String
        let appVersion = infoDictionary["CFBundleShortVersionString"] as! String
        let copyrightStatement = infoDictionary["NSHumanReadableCopyright"] as! String
        let developer = "maza.io"
        
        self.appName.stringValue = appName
        self.appName.sizeToFit()
        self.appVersion.stringValue.append(" \(appVersion)")
        self.copyright.stringValue = copyrightStatement
        self.appIconView.image = NSApp.applicationIconImage
        self.byDeveloper.stringValue = "by \(developer)"
    }
    
    func setWindowLook(){
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.isMovableByWindowBackground = true
        self.view.window?.backgroundColor = NSColor.white
        self.view.layer?.backgroundColor = NSColor.white.cgColor
    }
    @IBAction func viewLicenseWindow(_ sender: Any) {
        self.licenseController = LicenseWindowController(windowNibName: "LicenseWindow")
        self.licenseController?.window?.orderFront(self)
    }
}
