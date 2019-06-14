//
//  Constants.swift
//  audiofetch
//
//  Copyright © 2016 AudioFetch. All rights reserved.
//

import Foundation

// prefs
let PREF_LAST_VOLUME = "lastVolume"
let PREF_LAST_VOLUME_DEFAULT: Float = 0.65

// colors
let APP_COLOR_BLACK = UIColor(hex: 0x333333)
let APP_COLOR_BLUE = UIColor(hex: 0x5688B2)
let APP_COLOR_ORANGE = UIColor(hex: 0xCC6600)
let APP_COLOR_GREEN = UIColor(hex: K_APP_COLOR_GREEN)
let APP_COLOR_SILVER = UIColor(hex: 0xE7E7E7)


// fonts
let APP_PRIMARY_FONT_NAME = "HelveticaNeue-Medium"
let APP_SECONDARY_FONT_NAME = "HelveticaNeue-Thin"
let APP_BOLD_FONT_NAME = "HelveticaNeue-Bold"
let APP_NAVBAR_FONT = UIFont(name: APP_PRIMARY_FONT_NAME, size: 18.0)!
let APP_LABEL_FONT = UIFont(name: APP_SECONDARY_FONT_NAME, size: 17.0)!
let APP_VOLUME_FONT = UIFont(name: APP_BOLD_FONT_NAME, size: 20.0)!

//  app data
let APP_URI = "audiofetchsdk://"

// pref and api keys
let APPLE_APP_ID = ""

// standard strings
let STR_CONFIRMATION = NSLocalizedString("Confirmation", comment: "Confirmation")
let STR_YES = NSLocalizedString("Yes", comment: "Yes")
let STR_NO = NSLocalizedString("No", comment: "No")
let STR_CANCEL = NSLocalizedString("Cancel", comment: "Cancel")
let STR_OK = NSLocalizedString("OK", comment: "OK")
let STR_NAME = NSLocalizedString("Name", comment: "Name")
let STR_CHANNEL_NUM = NSLocalizedString("Channel %@", comment: "Channel %@")
let STR_FETCHING_AUDIO = NSLocalizedString("Fetching Audio...", comment: "Fetching Audio...")
let STR_NO_CONNECTION = NSLocalizedString("A connection was not found.  Please ensure that you are connected to an AudioFetch enabled WiFi network and restart the app.", comment: "A connection was not found.  Please ensure that you are connected to an AudioFetch enabled WiFi network and restart the app.")

let APP_NAME = NSLocalizedString("AudioFetch SDK Sample", comment: "AudioFetch SDK Sample")
let LOADING_CHANNELS = NSLocalizedString("Loading Channels...", comment: "Loading Channels...")
let REFRESHING_CHANNELS = NSLocalizedString("Refreshing Channels...", comment: "Refreshing Channels...")
let CHANNELS_NOT_LOADED = NSLocalizedString("No channels found!", comment: "No channels found!")

let APP_WIFI_MSG_BRANDED_SHORT = NSLocalizedString("Connect to AudioFetch WiFi...", comment: "Connect to AudioFetch WiFi...")
let APP_WIFI_MSG_BRANDED = NSLocalizedString("Please connect to AudioFetch-Enabled WiFi.", comment: "Please connect to AudioFetch-Enabled WiFi.")
