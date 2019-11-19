import Foundation

enum NSColorInitializerError: Error{
    case InvalidHexColorCode
}

enum LogLevel: Int {
    case Off = 0
    case Error = 1
    case Warn = 2   
    case Info = 3
    case Debug = 4
    case Trace = 5
}

enum PlistKey: String {
    case greetingMessage = "greetingMessage"
    
    case configuringMessage = "configuringMessage"
    case doNotTurnOffMessage = "doNotTurnOffMessage"
    case completedMessage = "completedMessage"
    
    case windowBackgroundColor = "windowBackgroundColor"
    case configuringWindowLevel = "configuringWindowLevel"
    case greetingColor = "greetingColor"
    case statusColor = "statusColor"
    case loglineColor = "loglineColor"
    case milestoneReachedTintColor = "milestoneReachedTintColor"
    case milestonePendingTintColor = "milestonePendingTintColor"
    
    case configuringContentUrl = "configuringContentUrl"
    case configuredContentUrl = "configuredContentUrl"
    
    case bannerEffectViewMaterial = "bannerEffectViewMaterial"
    case bannerEffectViewBlendingMode = "bannerEffectViewBlendingMode"
    case milestonesEffectViewMaterial = "milestonesEffectViewMaterial"
    case milestonesEffectViewBlendingMode = "milestonesEffectViewBlendingMode"
    case bannerBackgroundImageUrl = "bannerBackgroundImageUrl"
    
    case bannerForegroundImageUrl = "bannerForegroundImageUrl"
    
    case logFilePath = "logFilePath"
    case loglineTimestampDelimiter = "loglineTimestampDelimiter"
    case loglineTimestampDelimiterOffset = "loglineTimestampDelimiterOffset"
    case logFileEncoding = "logFileEncoding"
    case logFileChunkSize = "logFileChunkSize"
    case logLevel = "logLevel"
    
    case fullScreenConfigurationMode = "fullScreenConfigurationMode"
    case exitOnConfigurationComplete = "exitOnConfigurationComplete"
    
    case hideProgress = "hideProgress"
    case indeterminateProgress = "indeterminateProgress"
    case spinningProgress = "spinningProgress"
    
    case waypoints = "waypoints"
    case waypointVerifyCommand = "waypointVerifyCommand"
    case waypointIndex = "waypointIndex"
    case waypointTimerInterval = "waypointTimerInterval"
    
    case milestones = "milestones"
    case atWaypointIndex = "atWaypointIndex"
    case imagePath = "imagePath"
    case completedImagePath = "completedImagePath"
    
    static let rawValues: [String] = [
        greetingMessage.rawValue,
        
        configuringMessage.rawValue,
        doNotTurnOffMessage.rawValue,
        completedMessage.rawValue,
        
        windowBackgroundColor.rawValue,
        configuringWindowLevel.rawValue,
        greetingColor.rawValue,
        statusColor.rawValue,
        loglineColor.rawValue,
        milestoneReachedTintColor.rawValue,
        milestonePendingTintColor.rawValue,
        
        configuringContentUrl.rawValue,
        configuredContentUrl.rawValue,
        
        bannerEffectViewMaterial.rawValue,
        bannerEffectViewBlendingMode.rawValue,
        milestonesEffectViewMaterial.rawValue,
        milestonesEffectViewBlendingMode.rawValue,
        bannerBackgroundImageUrl.rawValue,
        bannerForegroundImageUrl.rawValue,
        
        logFilePath.rawValue,
        loglineTimestampDelimiter.rawValue,
        loglineTimestampDelimiterOffset.rawValue,
        logFileEncoding.rawValue,
        logFileChunkSize.rawValue,
        logLevel.rawValue,
        
        fullScreenConfigurationMode.rawValue,
        exitOnConfigurationComplete.rawValue,
        
        hideProgress.rawValue,
        indeterminateProgress.rawValue,
        spinningProgress.rawValue,
        
        waypoints.rawValue,
        waypointVerifyCommand.rawValue,
        waypointIndex.rawValue,
        waypointTimerInterval.rawValue,
        
        milestones.rawValue,
        atWaypointIndex.rawValue,
        imagePath.rawValue,
        completedImagePath.rawValue,
    ]
}
