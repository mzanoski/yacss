import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var logFeedback: NSTextField!
    @IBOutlet weak var greeting: NSTextField!
    @IBOutlet weak var milestoneStack: NSStackView!
    @IBOutlet weak var statusMessage: NSTextField!
    @IBOutlet weak var bannerImageView: NSImageView!
    @IBOutlet weak var bannerEffectsView: NSVisualEffectView!
    @IBOutlet weak var milestonesEffectsView: NSVisualEffectView!
    
    let appSettings = (NSApplication.shared().delegate as! AppDelegate).appSettings
    var remainingWaypoints: [Waypoint]? = (NSApplication.shared().delegate as! AppDelegate).appSettings.getPreference(forKey: PlistKey.waypoints.rawValue)
    var milestones: [Milestone]? = (NSApplication.shared().delegate as! AppDelegate).appSettings.getPreference(forKey: PlistKey.milestones.rawValue)
    let logger = (NSApplication.shared().delegate as! AppDelegate).logger
    var logFileHandle: FileHandle? = nil
    var waypointCheckTimer: Timer? = nil
    var logCheckTimer: Timer? = nil
    var configurationComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear() {
        configureBannerVisualEffectsView()
        configureMilestonesVisualEffectsView()
        configureGreeting()
        configureMessage()
        configureWindowBackgroundColor()
        configureProgressIndicator()
        configureLogFeedback()
        configureWebView(contentUrl: PlistKey.configuringContentUrl.rawValue)
        
        // sort milestones
        if let milestones = self.milestones{
            self.milestones = milestones.sortedByWaypointIndex
        }
        configureMilestoneStack(milestones: self.milestones)
        
        // waypoint timer defaults to 0.5 if not specified in preferences
        var waypointInterval = TimeInterval(0.5)
        if let wInterval:String = appSettings.getPreference(forKey: PlistKey.waypointTimerInterval.rawValue){
            if let dWInterval = Double(wInterval){
                waypointInterval = TimeInterval(dWInterval)
            }
        }
        waypointCheckTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(waypointInterval),
            target: self,
            selector: #selector(checkWaypoint),
            userInfo: nil,
            repeats: true
        )
        
        // create timer to check log file only of a log file path is in preferences
        if let logFilePath: String = appSettings.getPreference(forKey: PlistKey.logFilePath.rawValue){
            self.logFileHandle = getFileHandle(filePath: logFilePath)
            
            // log check timer
            logCheckTimer = Timer.scheduledTimer(
                timeInterval: TimeInterval(0.1),
                target: self,
                selector: #selector(getLastLogLine),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    override func viewDidAppear() {
        // this window should float above other windows to avoid being hidden so that users can read web content without being interrupted
        let windowLevel: Int = appSettings.getPreference(forKey: PlistKey.configuringWindowLevel.rawValue)!  // this settings will always exist
        self.view.window?.level = windowLevel
        
        let presentationOptions: NSApplicationPresentationOptions = [.hideDock, .hideMenuBar, .disableAppleMenu, .disableProcessSwitching, .disableHideApplication]
        let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions: NSNumber(value: presentationOptions.rawValue)]
        
        if self.appSettings.getPreference(forKey: PlistKey.fullScreenConfigurationMode.rawValue) {
            if !configurationComplete{
                self.view.enterFullScreenMode(NSScreen.main()!, withOptions:optionsDictionary)
                // in full screen mode, make this top-most window
                self.view.window?.level = Int(CGWindowLevelForKey(.maximumWindow))
            }
        }
        self.view.wantsLayer = true
    }
    
    func configureBannerVisualEffectsView(){
        self.bannerEffectsView.isHidden = true
        
        if let material:Int = appSettings.getPreference(forKey: PlistKey.bannerEffectViewMaterial.rawValue),
            let blendingMode:Int = appSettings.getPreference(forKey: PlistKey.bannerEffectViewBlendingMode.rawValue){
            self.bannerEffectsView.material = NSVisualEffectMaterial(rawValue: material)!
            self.bannerEffectsView.blendingMode = NSVisualEffectBlendingMode(rawValue: blendingMode)!
            self.bannerEffectsView.isHidden = false
        }
    }
    
    func configureMilestonesVisualEffectsView(){
        self.milestonesEffectsView.isHidden = true
        
        if let material:Int = appSettings.getPreference(forKey: PlistKey.milestonesEffectViewMaterial.rawValue),
            let blendingMode:Int = appSettings.getPreference(forKey: PlistKey.milestonesEffectViewBlendingMode.rawValue){
            self.milestonesEffectsView.material = NSVisualEffectMaterial(rawValue: material)!
            self.milestonesEffectsView.blendingMode = NSVisualEffectBlendingMode(rawValue: blendingMode)!
            self.milestonesEffectsView.isHidden = false
        }
    }
    
    func configureGreeting(){
        let formatter = PersonNameComponentsFormatter()
        
        if let nameComponents = formatter.personNameComponents(from: NSFullUserName()){
            if let givenName = nameComponents.givenName{
                self.greeting.stringValue = String(format: appSettings.getPreference(forKey: PlistKey.greetingMessage.rawValue)!, givenName)
            }
        }
        else{
            self.greeting.stringValue = String(format: appSettings.getPreference(forKey: PlistKey.greetingMessage.rawValue)!, NSFullUserName())
        }
        
        if let color:NSColor = appSettings.getPreference(forKey: PlistKey.greetingColor.rawValue){
            self.greeting.textColor = color
        }
    }
    
    func configureMessage(){
        var configuring = ""
        var doNotTurnOff = ""
        
        if let conf:String = appSettings.getPreference(forKey: PlistKey.configuringMessage.rawValue){
            configuring = conf
        }
        
        if let dnto:String = appSettings.getPreference(forKey: PlistKey.doNotTurnOffMessage.rawValue){
            doNotTurnOff = dnto
        }
        
        let message = "\(configuring) \(doNotTurnOff)"
        self.statusMessage.stringValue = message
        
        if let color:NSColor = appSettings.getPreference(forKey: PlistKey.statusColor.rawValue){
            self.statusMessage.textColor = color
        }
    }
    
    func configureWindowBackgroundColor(){
        if let windowBackgroundColor: NSColor = appSettings.getPreference(forKey: PlistKey.windowBackgroundColor.rawValue){
            self.view.layer?.backgroundColor = windowBackgroundColor.cgColor
            self.view.window?.backgroundColor = windowBackgroundColor
        }
        
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.titleVisibility = .hidden
        self.view.window?.isMovableByWindowBackground = true
    }
    
    func configureProgressIndicator(){
        self.progressIndicator.isIndeterminate = appSettings.getPreference(forKey: PlistKey.indeterminateProgress.rawValue)
        
        if appSettings.getPreference(forKey: PlistKey.spinningProgress.rawValue){
            // TODO: figure out how to move the spinning determinate progress to middle
            // TODO: update width constraint
//            self.progressIndicator.frame.size.width = self.progressIndicator.frame.size.height
//            self.progressIndicator.widthAnchor.constraint(equalToConstant: self.progressIndicator.frame.height)
//            self.progressIndicator.displayIfNeeded()

            self.progressIndicator.style = .spinningStyle
        }
        
        if appSettings.getPreference(forKey: PlistKey.hideProgress.rawValue) {
            self.progressIndicator.isHidden = true
        }
        
        // set max progress indicator value to the number of waypoints
        if let maxWaypoint = self.remainingWaypoints?.maxWaypoint{
            self.progressIndicator.maxValue = Double(maxWaypoint.index)
        }
        self.progressIndicator.startAnimation(nil)
    }
    
    func configureLogFeedback(){
        self.logFeedback.stringValue = ""
        self.logFeedback.isHidden = true
        if let logUrl: String = appSettings.getPreference(forKey: PlistKey.logFilePath.rawValue){
            if !logUrl.isEmpty {
                self.logFeedback.isHidden = false
            }
        }
        
        if let color:NSColor = appSettings.getPreference(forKey: PlistKey.loglineColor.rawValue){
            self.logFeedback.textColor = color
        }
    }
    
    func configureWebView(contentUrl: String){
        self.webView.mainFrameURL = appSettings.getPreference(forKey: contentUrl)
    }
    
    func configureMilestoneStack(milestones: [Milestone]?){
        self.milestoneStack.subviews.removeAll()
        
        // milestones are just references to waypoint indexes (which may or may not exist)
        guard milestones != nil else {
            self.milestoneStack.isHidden = true
            return
        }
        
        for milestone in milestones!.sortedByWaypointIndex {
            // enforce max 5 milestones.  this is a bit arbitrary but then how many milestones can you have?  At some point, they're not milestones anymore.
            guard self.milestoneStack.subviews.count < 6 else {
                return
            }
            
            // create milestone imageView
            let image = configureMilestoneImage(milestone: milestone)
            let mImageView = NSImageView(image: image)
            
            // add milestone to stack view
            milestone.view = mImageView
            self.milestoneStack.addView(mImageView, in: .trailing)
        }
    }
    
    func getLastLogLine(timer: Timer){
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            let lastLogLine = readLastLogLine(fileHandle: self.logFileHandle)
            
            DispatchQueue.main.async{
                if let message = lastLogLine {
                    self.logFeedback.stringValue = message
                }
                
                if self.remainingWaypoints == nil {
                    timer.invalidate()
                }
            }
        }
    }
    
    func checkWaypoint(timer: Timer){
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            let result = getNextWaypoint(waypoints: self.remainingWaypoints)
            self.remainingWaypoints = result.remainingWaypoints
            let currentWaypoint = result.currentWaypoint
            
            DispatchQueue.main.async{
                self.setProgressIndicatorStatus(waypoint: currentWaypoint)
                self.setMilestoneStatus(waypoint: currentWaypoint)
                
                if self.remainingWaypoints == nil {
                    self.setCompletedStatus()
                    timer.invalidate()
                }
            }
        }
    }
    
    func setProgressIndicatorStatus(waypoint: Waypoint?){
        if let progressValue = waypoint?.index{
            self.progressIndicator.doubleValue = Double(progressValue)
        }
    }
    
    func setMilestoneStatus(waypoint: Waypoint?){
        if let progressValue = waypoint?.index{
            if let milestoneToSet = self.milestones?.nextPendingMilestone{
                logger?.debug(message: "milestoneToSet waypointIndex: \(milestoneToSet.atWaypointIndex)")
                logger?.debug(message: "milestoneToSet getImagePath(): \(milestoneToSet.getImagePath())")
                logger?.debug(message: "milestoneToSet view.image.size: \(milestoneToSet.view?.image?.size)")
                
                if milestoneToSet.atWaypointIndex <= progressValue{
                    milestoneToSet.reached = true
                    let image = configureMilestoneImage(milestone: milestoneToSet)
                    let newImageView = NSImageView(image: image)
                    newImageView.frame = milestoneToSet.view!.frame
                    self.milestoneStack.animator().replaceSubview(milestoneToSet.view!, with: newImageView)
                }
            }
        }
    }
    
    func configureMilestoneImage(milestone: Milestone) -> NSImage{
        var image = NSImage(byReferencingFile: milestone.getImagePath())
        image!.size = NSSize(width: 64, height: 64)
        
        if milestone.reached{
            if let tintColor:NSColor = appSettings.getPreference(forKey: PlistKey.milestoneReachedTintColor.rawValue){
                image = image?.setTint(toColor: tintColor)
            }
        }
        else{
            if let tintColor:NSColor = appSettings.getPreference(forKey: PlistKey.milestonePendingTintColor.rawValue){
                image = image?.setTint(toColor: tintColor)
            }
        }
        return image!
    }
    
    func setCompletedStatus(){
        self.configurationComplete = true
        
        // log and progress bar fade out
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2
            self.logFeedback.animator().alphaValue = 0.0
            self.progressIndicator.animator().alphaValue = 0.0
            self.milestoneStack.animator().alphaValue = 0.2
        }, completionHandler: {
            self.logFeedback.isHidden = true
            self.progressIndicator.isHidden = true
            
            // TODO: fade the status message??
            self.statusMessage.stringValue = ""
            
            if let completedMessage:String = self.appSettings.getPreference(forKey: PlistKey.completedMessage.rawValue){
                self.statusMessage.stringValue = completedMessage
            }
            
            self.updateWindowOnConfigurationComplete()
        })
        
        // TODO: fade in new web content
        if let configurationCompletePage:String = appSettings.getPreference(forKey: PlistKey.configuredContentUrl.rawValue){
            self.webView.mainFrameURL = configurationCompletePage
        }
    }
    
    func updateWindowOnConfigurationComplete(){
        if appSettings.getPreference(forKey: PlistKey.exitOnConfigurationComplete.rawValue){
            (NSApplication.shared().terminate(self))
        }
        else{
            self.view.animator().exitFullScreenMode(options: nil)
            // reset window level value to default
            let windowLevel: Int = Int(CGWindowLevelForKey(.normalWindow))
            self.view.window?.level = windowLevel
            // TODO: some animation would be nice here
        }
    }
    
}
