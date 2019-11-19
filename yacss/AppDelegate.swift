import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var aboutWindowController: AboutWindowController? = nil
    var appSettings = AppSettings()
    // TODO: find proper place to initialize logger
    var logger:Logger? = Logger(directory: "/Users/\(NSUserName())/Library/Logs/")
    
    func applicationWillFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.logger?.setLogTo(level: appSettings.getPreference(forKey: PlistKey.logLevel.rawValue))
        NSApplication.shared().mainWindow?.minSize = NSSize(width: 1000, height: 800)
    }
    
    @IBAction func about(_ sender: Any) {
        self.aboutWindowController = AboutWindowController(windowNibName: "AboutWindow")
        self.aboutWindowController?.window?.orderFront(self)
    }
}

