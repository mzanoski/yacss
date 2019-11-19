===================
yacss Configuration
===================
The main goal yacss attempts to meet is flexibility.  In order to meet this goal, yacss makes it possible for
administrator(s) to control the progress bar, milestones bar, log file feedback, and look & feel of the application
through io.maza.yacss.plist in user preferences folder.

Before using yacss, ensure that it has been configured to work with your environment.

For all plist keys/value details, see the plistReference_ section.


Configuring Functionality
=========================
.. _waypoints:

Waypoints
---------
The first and most important part of configuration is setting up waypoints for your environment.  The list of waypoints
that you configure will be used to verify configuration status and provide feedback through progress bar, milestones,
and let the user know when configuration has completed.

yacss takes the approach of verifying the device state rather than attempting to obtain information from MDM server.  The
administrator must define how each waypoint will be verified using a shell command.  All waypoints are stored in the
"waypoints" array and each waypoint is a dictionary consisting of:

    1. waypointVerifyCommand: String
        - The command must return a value representing boolean "true" if item has been configured or "false" otherwise
            - true: string starting with "Y", "y", "T", "t", or a digit 1-9
            - NSString.boolValue boolValueReference_
                .. _boolValueReference: https://developer.apple.com/reference/foundation/nsstring/1409420-boolvalue

        - In general, anything you can execute as a terminal command should work

    2. waypointIndex: Int
        - Arbitrary integer value representing the position of the waypoint in configuration sequence

example::

    waypoints =     (
                {
            waypointIndex = 50;
            waypointVerifyCommand = "echo \\"1\\"";
        },
                {
            waypointIndex = 40;
            waypointVerifyCommand = "echo \\"1\\"";
        },
                {
            waypointIndex = 33;
            waypointVerifyCommand = "echo \\"1\\"";
        }
    );

Administrators should take care to ensure that waypointVerifyCommand executes quickly and efficiently (less than the
waypointTimerInterval value).  Stay away from long and complex verifications.  If the item cannot be verified quickly
and without using complex script/command, then it is possible that this particular item should not be used as a waypoint.

Waypoints are evaluated sequentially and evaluation moves ahead only when the current waypoint command evaluates to "true".


.. _milestones:

Milestones
----------
A milestone is a reference to a point in configuration sequence (a configuration sequence is defined by waypoints).
Once configuration passes a given point defined by a milestone, that milestone has been reached and user feedback is
provided visually by updating that milestone's image in the milestone bar.

Milestones are defined in the "milestones" array where each items is a dictionary consisting of:

    1. atWaypointIndex: Int
        - integer value representing the point in config sequence when the milestone has been reached
        - value should, but does not have to be a value of an existing waypoint
        - if atWaypointIndex value is <= current waypoint value, this milestone has been reached
        - ensure that duplicate "atWaypointIndex" values do not exist in milestones array

    2. imagePath: String
        - file path of the image representing this milestone

    3. completedImagePath: String
        - optional value of the image to be displayed once milestone has been reached


example::

 milestones =     (
                {
            atWaypointIndex = 10;
            completedImagePath = "/Users/mzanoski/source/maza.io/yacss/yacss/av-icon-64-done.png";
            imagePath = "/Users/mzanoski/source/maza.io/yacss/yacss/av-icon-64.png";
        },
                {
            atWaypointIndex = 20;
            completedImagePath = "/Users/mzanoski/source/maza.io/yacss/yacss/wifi-icon-64.png";
            imagePath = "/Users/mzanoski/source/maza.io/yacss/yacss/wifi-icon-64.png";
        }
    );

An example of a milestone might be the point at which device security settings have been configured or when all the
entire configuration has been completed.

You don't have to define any milestones, but you can have at most five.  Milestones are purely meant as a visual feedback
for users.


.. _greetingMessage:

Greeting Message
----------------
By default, the greeting message is set to "Welcome {User's first name}".  If first name cannot be determined, logged in
user's full name is displayed.

Change the default greeting message by modifying the "greetingMessage" value.  If you want to omit user's name, remove
"%@" from the greeting message.

example::

    greetingMessage = "Welcome %@!";
    greetingMessage = "Hello World!";


.. _statusMessage:

Status Message
--------------
Status message is displayed immediately below the greeting message.  While configuration is in progress, the status
message is a concatenation of "configuringMessage" and "doNotTurnOffMessage" values.

example::

    configuringMessage = "Configuring...";
    doNotTurnOffMessage = "Do not shut off or disconnect the deivce.";

While configuration is in progress, above settings will set the status message to:
"Configuring...Do not shut off or disconnect the deivce."

Once configuration has completed, status message is set to the value of "completedMessage" key.


.. _logFileFeedback:

Log File Feedback
-----------------
If desired, you can display the last log entry during configuration of any one log file you choose.  Typically this would
be an MDM server log file (eg: /var/log/jamf.log).

Log file info will only display if "logFilePath" key is set to a valid log file path.

example::

    logFilePath = "/var/log/jamf.log";

Log message line is intended to display the actual message, omitting timestamp or any other undesired preceding info.
In order to do this, yacss needs to know at which point in the log entry to split text.  This information may be different
for different log files.  The default values are listed in the below snippet and work with jamf.log.

example::

    loglineTimestampDelimiter = "]";
    loglineTimestampDelimiterOffset = 3;
    logFileEncoding = 4;

Above settings tell yacss to split the log line text at index of "]" character + 3.

The default file encoding is set to UTF8 and may be changed by modifying the "logFileEncoding" key where the value is an
integer representing a String.Encoding value.  See stringEncodingLink_.


.. _webContentArea:

Web Content Area
________________
Main body of yacss (below milestones bar and above progress bar), is intended to display web content during device
configuration with option of displaying different content once configuration has been completed.

To configure web content, set the below key values to desired URLs:

::

    configuringContentUrl = "/Path/To/page.html";
    configuredContentUrl = "/Path/To/page.html";

The "configuredContentUrl" key is optional and if not set, "configuringContentUrl" will continue to display once the device
has been configured.

For best results, set the web page background color to windowBackgroundColor and ensure that web pages do not require
users to authenticate.


.. _configurationCompletedOptions:

Configuration Completed Options
-------------------------------
Depending on your requirements, yacss can do a few different things once device configuration has been completed.

NOTE: configuration has been completed when the last waypoint has been completed.

yacss can:
    - terminate
    - exit full screen (if it was configured for "fullScreenConfigurationMode")
    - display "completed" web page in web content area

1. To terminate yacss, set "exitOnConfigurationComplete" bool key to true.
2. To exit full screen, set "exitOnConfigurationComplete" bool to false.
3. To display "completed" web page, set "configuredContentUrl" string key to desired URL


.. _lookAndFeel:

Look and Feel
=============
This project aims to give administrator(s) the ability to customize the look and feel of yacss to match their requirements
and make their MDM screen unique.

NOTE: all color values may be preceded by "0x" or not and are expected to be a valid 6-digit hex value.

Following options are available:


Window Background Color
-----------------------
The default window background color is set to 0xECECEC.  Change the window background color by setting the
"windowBackgroundColor" value to desired hex color value string.

example::

    windowBackgroundColor = ECECEC;
    windowBackgroundColor = 0xECECEC;



Window Level
------------
The z-index of yacss window when not in full-screen mode is determined by the "configuringWindowLevel" integer value.  The
default value is set to CGWindowLevelKey.floatingWindow and is in effect while configuration is in progress only.  If
window level is set to a value higher than "normalWindow" then any other windows that may open during configuration will
remain behind yacss window.

See cgWindowLevelKey_

Once device configuration has completed, the window level is set to CGWindowLevelKey.normalWindow.


Banner Image
------------
Banner area is the portion of yacss window above the milestones section.

Banner area can display a desired banner image by setting the "bannerBackgroundImageUrl" value to the path of the banner
image.


.. _bannerEffectView:

Banner Effect View
------------------
Background style of banner area is by default, the same color as the window unless "bannerEffectViewBlendingMode" and
"bannerEffectViewMaterial" integer values are defined.  These two values can be changed to give the banner area a
desired translucency effect.

 bannerEffectViewBlendingMode values:
    - 0: behindWindow
    - 1: withinWindow (change the translucency effect by setting the bannerBackgroundImage)

 bannerEffectViewMaterial values:
    - 0: appearanceBased
    - 1: light
    - 2: dark
    - 3: titlebar
    - 4: selection
    - 5: menu
    - 6: popover
    - 7: sidebar
    - 8: mediumLight
    - 9: ultraDark


Milestones Bar Images
---------------------
You can define up to five milestones.  Each milestone must have at least one image defined ("imagePath").

You can define (or not), a "completedImagePath" for each milestone.

You can change (or not), "milestonePendingTintColor" and "milestoneReachedTintColor".  Defaults are set to
NSColor.controlBackgroundColor and NSColor.alternateSelectedControlColor but setting either of the keys to "" (empty
string) will remove the tint from either pending or reached (or both) milestone state image.  Tint color settings apply
to all milestones.


If you define only imagePath and set both tint color values to "", milestones image will remain static. If "milestones"
array is empty or not defined in plist, milestone images will not be displayed.


Milestones Bar Background
-------------------------
Background style of milestone space is the same color as the window unless "milestonesEffectViewBlendingMode" and
"milestonesEffectViewMaterial" integer values are defined.  These two values can be changed to give the milestone bar a
desired translucency effect.

 milestoneEffectViewBlendingMode values:
    - 0: behindWindow
    - 1: withinWindow

 milestonesEffectViewMaterial values:
    - 0: appearanceBased
    - 1: light
    - 2: dark
    - 3: titlebar
    - 4: selection
    - 5: menu
    - 6: popover
    - 7: sidebar
    - 8: mediumLight
    - 9: ultraDark


Progress Bar
------------
You can choose to display either determinate or indeterminate progress in either bar or spinning styles.  Set the
"hideProgress" bool value to "true" to hide progress.


Greeting Color
--------------
The color of the greeting message can be set by modifying the "greetingColor" key.


Status Color
------------
The color of the status message ca ge set by modifying the "statusColor" key.


Log File Feedback
-----------------
The color of the log feedback line (if displayed) can be set by modifying the "loglineColor" key



.. _plistReference:

io.maza.yacss.plist reference
=============================


================================= ========== ==========
               key                  type     info
================================= ========== ==========
completedMessage                  string     Displayed in message area when configuration has completed
configuringMessage                string     Displayed in message area during configuration
doNotTurnOffMessage               string     Displayed in message area during configuration and following the configuringMessage
configuringContentUrl             string     URL of the page to be displayed during configuration
configuredContentUrl              string     URL of the page to be displayed when configuration has completed
greetingMessage                   string     Greeting message.  Keep "%@" in the value to display user's first name or full name
                                             if first name cannot be determined
windowBackgroundColor             string     yacss window color.  Must be a six digit hex number and may start with "0x"
configuringWindowLevel            int        z-index of yacss window when not in full-screen mode. See cgWindowLevelKey_
greetingColor                     string     Greeting message color.  Must be a six digit hex number and may start with "0x"
statusColor                       string     Color of the status message displayed immediately below greeting message.
                                             Must be a six digit hex number and may start with "0x"
loglineColor                      string     Color of the log feedback line. Must be a six digit hex number and may start with "0x"
milestonePendingTintColor         string     Tint of milestone images before they have been reached: Must be a six digit hex number
                                             and may start with "0x"
milestoneReachedTintColor         string     Tint of milestone images after they have been reached: Must be a six digit hex number
                                             and may start with "0x"


logFilePath                       string     Path to the log file from which feedback should be displayed (eg: /var/log/jamf.log)
logFileEncoding                   int        raw value (int) of String.Encoding (see stringEncodingLink_)
logFileChunkSize                  int        Optional: number of bytes of the log file that are read (from bottom/end) when extracting
                                             the last line of the file.

loglineTimestampDelimiter         string     Character in the log line whose first occurance will be used to split the line and
                                             discard the left side of.  If string is longer than one character, the first character
                                             is taken.
loglineTimestampDelimiterOffset   int        Split the log line on first occurance of above character plus this offset value

exitOnConfigurationComplete       bool       Exit yacss once when configuration has completed
fullScreenConfigurationMode       bool       Display yacss in full screen mode while configuration is in progress
hideProgress                      bool       Hide progress on the bottom of yacss
indeterminateProgress             bool       Display progress in indeterminate mode
spinningProgress                  bool       Display spinning style progress
logLevel                          int        Maximum logging level output to ~/Library/Logs/yacss.log.
                                             0: off, 1: Error, 2: Warn, 3: Info, 4: Debug, 5: Trace

milestonesEffectViewBlendingMode  int        Blending mode of the milestone effect view.  0: behindWindow, 1: withinWindow
                                             See bannerEffectView_
milestonesEffectViewMaterial      int        Effect view style. See bannerEffectView_
bannerEffectViewBlendingMode      int        See bannerEffectView_
bannerEffectViewMaterial          int        See bannerEffectView_

waypointTimerInterval             string     A decimal value representing time inteval (in seconds), at which yacss checks
                                             waypoint status.  Default value is 0.5 seconds.
waypoints                         array      An array of dictionaries where each dictionary must contain both of
                                             "waypointVerifyCommand" and "waypointIndex" keys.
waypointIndex                     int        Arbitrary int value representing the position of this waypoint in configuration
                                             sequence.
waypointVerifyCommand             string     Terminal command used to verify whether this waypoint has been reached.
                                             Command must return "Y", "y", "T", "t", or a digit 1-9 for"true".  Any other
                                             value is interpreted as "false".  See boolValueReference_
milestones                        array      An array of dictionaries where each dictionary contains "atWaypointIndex",
                                             "imagePath", and "completedImagePath" (optional)
atWaypointIndex                   int        Int value representing a point in configuration sequence when this milestone
                                             is reached.
imagePath                         string     Path to the image representing this milestone
completedImagePath                string     Optional path to the image representing this milestone in reached (completed) state.
================================= ========== ==========

.. _stringEncodingLink: https://developer.apple.com/reference/foundation/string.encoding

.. _cgWindowLevelKey: https://developer.apple.com/reference/coregraphics/cgwindowlevelkey


default values
--------------
Below are default values that will be created when yacss runs if io.maza.yacss does not already exist.
::

 {
    completedMessage = "Configured.";
    configuringMessage = "Configuring...";
    doNotTurnOffMessage = "Do not shut off or disconnect the deivce.";
    configuringContentUrl = "/Users/mzanoski/source/maza.io/yacss/configuring.html";
    exitOnConfigurationComplete = 0;
    fullScreenConfigurationMode = 0;
    greetingColor = 1B1B1B;
    greetingMessage = "Welcome %@!";
    logFileEncoding = 4;
    logFilePath = "/var/log/jamf.log";
    loglineColor = BABABA;
    loglineTimestampDelimiter = "]";
    loglineTimestampDelimiterOffset = 3;
    milestonePendingTintColor = FFFFFF;
    milestoneReachedTintColor = 0069D9;
    statusColor = 808080;
    windowBackgroundColor = ECECEC;
    configuringWindowLevel = 5;
 }


live configuration example
--------------------------
::

 {
    "NSToolbar Configuration com.apple.NSColorPanel" =     {
        "TB Is Shown" = 1;
    };
    PMPrintingExpandedStateForPrint2 = 0;
    completedMessage = "Your Mac is configured";
    configuringMessage = "Configuring...";
    doNotTurnOffMessage = "Do not shut off or disconnect the deivce.";
    configuredContentUrl = "https://apple.com";
    configuringContentUrl = "/Users/mzanoski/source/maza.io/yacss/configuring.html";
    exitOnConfigurationComplete = 0;
    fullScreenConfigurationMode = 0;
    greetingColor = 1B1B1B;
    greetingMessage = "Welcome %@!";
    hideProgress = 0;
    indeterminateProgress = 0;
    logFileEncoding = 4;
    logFilePath = "/var/log/jamf.log";
    logLevel = 5;
    loglineColor = BABABA;
    loglineTimestampDelimiter = "]";
    loglineTimestampDelimiterOffset = 3;
    milestonePendingTintColor = FFFFFF;
    milestoneReachedTintColor = 007A00;
    milestones =     (
                {
            atWaypointIndex = 10;
            imagePath = "/System/Library/PreferencePanes/Accounts.prefPane/Contents/Resources/AccountsPref.icns";
        },
                {
            atWaypointIndex = 20;
            imagePath = "/System/Library/PreferencePanes/AppStore.prefPane/Contents/Resources/appStore.icns";
        },
                {
            atWaypointIndex = 30;
            imagePath = "/System/Library/PreferencePanes/Network.prefPane/Contents/Resources/Network.icns";
        },
                {
            atWaypointIndex = 40;
            imagePath = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/FileVaultIcon.icns";
        },
                {
            atWaypointIndex = 50;
            imagePath = "/System/Library/PreferencePanes/Profiles.prefPane/Contents/Resources/Profiles.icns";
        }
    );
    milestonesEffectViewBlendingMode = 0;
    milestonesEffectViewMaterial = 8;
    rebootingMessage = "Rebooting in %d minutes";
    spinningProgress = 0;
    statusColor = 808080;
    waypointTimerInterval = "0.5";
    waypoints =     (
                {
            waypointIndex = 50;
            waypointVerifyCommand = "echo \\"1\\"";
        },
                {
            waypointIndex = 40;
            waypointVerifyCommand = "system_profiler SPConfigurationProfileDataType | grep -wic 'CheckInURL = "https://mdmserver'";
        },
                {
            waypointIndex = 32;
            waypointVerifyCommand = "spctl --status | grep -c enabled";
        },
                {
            waypointIndex = 31;
            waypointVerifyCommand = "fdesetup status | grep -wic \\"filevault is on\\"";
        },
                {
            waypointIndex = 22;
            waypointVerifyCommand = "defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist | grep -c 'SSIDString = \\"CompanyWifi\\"'";
        },
                {
            waypointIndex = 21;
            waypointVerifyCommand = "networksetup -getsearchdomains Wi-Fi | grep -c mycompanydomain.com";
        },
                {
            waypointIndex = 12;
            waypointVerifyCommand = "ls /Users/`stat -f%Su /dev/console`/Library/Application\ Support/Citrix/EPAPlugin | grep -c CitrixEndpointAnalysis.app";
        },
                {
            waypointIndex = 11;
            waypointVerifyCommand = "ls /Library/Application\ Support/Citrix | grep -c NetScaler\ Gateway.app";
        },
                {
            waypointIndex = 3;
            waypointVerifyCommand = "id -nG `stat -f%Su /dev/console` | grep -vwc admin";
        },
                {
            waypointIndex = 2;
            waypointVerifyCommand = "id -nG Admin | grep -wc admin";
        },
                {
            waypointIndex = 1;
            waypointVerifyCommand = "dscl . -list /Users | grep -c Admin";
        }
    );
    windowBackgroundColor = ECECEC;
    configuringWindowLevel = 5;
 }
