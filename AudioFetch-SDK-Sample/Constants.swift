//
//  Constants.swift
//  audiofetch
//
//  Copyright © 2016 AudioFetch. All rights reserved.
//

import Foundation

let TOAST_CENTER = "center"
let TOAST_TOP = "top"
let TOAST_BOTTOM = "bottom"

// colors
let APP_COLOR_BLACK = UIColor(hex: 0x333333)
let APP_COLOR_BLUE = UIColor(hex: 0x5688B2)
let APP_COLOR_ORANGE = UIColor(hex: 0xCC6600)
let APP_COLOR_SILVER = UIColor(hex: 0x777777)

// fonts
let APP_NAVBAR_FONT_NAME = "HelveticaNeue-Medium"
let APP_BOLD_FONT_NAME = "HelveticaNeue-Bold"
let APP_NAVBAR_FONT = UIFont(name: APP_NAVBAR_FONT_NAME, size: 18.0)!
let APP_MENU_FONT = UIFont(name: APP_NAVBAR_FONT_NAME, size: 20.0)!

// rest api
let APP_REST_BASE_HOST = "https://www.audiofetch.com"
let APP_REST_BASE_URI = APP_REST_BASE_HOST + "/wp-content/plugins/waio/api"

//  app data
let APP_PHONE = "8444433824"
let APP_URI = "audiofetch://"
let APP_SHARE_URL = "http://www.audiofetch.com/"

// pref and api keys
let APPLE_APP_ID = ""
let APP_FLURRY_KEY = "TXTKSFCGMF4MVR2ZYMJM"
let APP_PREFS_LAST_SYNC = "LastSyncDate"


let APP_NAME = NSLocalizedString("AudioFetch", comment: "AudioFetch")
let APP_SHARE_MSG = NSLocalizedString("Check out AudioFetch!", comment: "Check out AudioFetch!")

let APP_WIFI_MSG_BRANDED_SHORT = NSLocalizedString("Connect to AudioFetch WiFi...", comment: "Connect to AudioFetch WiFi...")
let APP_WIFI_MSG_BRANDED = NSLocalizedString("Please connect to AudioFetch-Enabled WiFi.", comment: "Please connect to AudioFetch-Enabled WiFi.")
let APP_CONTACT_ALERT = NSLocalizedString("Would you like to contact BroadcastVision about advertising?", comment: "advertising?")

// email
let APP_EMAIL_SUBJ = NSLocalizedString("AudioFetch Feedback", comment: "AudioFetch Feedback")
let APP_EMAIL_BODY = NSLocalizedString("We welcome your feedback.  Please be as specific as possible relative to your feedback and the service location.", comment: "feedback email")
let APP_EMAIL_CONFIRM = NSLocalizedString("Your message has been sent.", comment: "Your message has been sent.")
let APP_EMAIL_AD_SUBJ = NSLocalizedString("AudioFetch Sponsor Contact", comment: "AudioFetch Sponsor Contact")

// standard strings
let STR_CONFIRMATION = NSLocalizedString("Confirmation", comment: "Confirmation")
let STR_YES = NSLocalizedString("Yes", comment: "Yes")
let STR_NO = NSLocalizedString("No", comment: "No")
let STR_CANCEL = NSLocalizedString("Cancel", comment: "Cancel")
let STR_OK = NSLocalizedString("OK", comment: "OK")
let STR_NAME = NSLocalizedString("Name", comment: "Name")

// app strings
let STR_EMAIL_SUCCESS = NSLocalizedString("Email was sent successfully.", comment: "Email sent!")
let STR_EMAIL_FAILURE = NSLocalizedString("Email failed to send, check your email settings and try again.", comment: "Email failed")
let STR_FETCHING_AUDIO = NSLocalizedString("Fetching Audio...", comment:"Fetching Audio...")
let STR_CHANNEL_NUM = NSLocalizedString("Channel %d", comment: "Channel %d")
let STR_START_DEMO = NSLocalizedString("Starting Demo Mode...", comment: "Starting Demo Mode...")
let STR_AF_EXPRESS = NSLocalizedString("AudioFetch Express", comment: "AudioFetch Express")
let STR_WIFI_FORMAT = NSLocalizedString("CONNECTED TO WIFI: %@", comment:"CONNECTED WIFI: NAME")


