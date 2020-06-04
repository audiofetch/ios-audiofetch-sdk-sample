//
//  Constants.h
//  audiofetch
//
//

#ifndef audiofetch_Constants_h
#define audiofetch_Constants_h
//====================================================================================

#ifndef UIKIT_EXTERN
#import <UIKit/UIKit.h>
#endif

/*====================================================================================
// AFETCH_FRAMEWORK_EXTERN
//===================================================================================*/


#ifndef afetch_framework_extern_h
#import "afetch_framework_extern.h"
#endif


/*====================================================================================
// MACROS
//===================================================================================*/



#ifdef DEBUG
#   define DLog(__FORMAT__, ...) NSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...) do {} while (0)
#endif

// iOS Version Checking
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// VARIOUS STRING MACROS
#define STRING_NOT_NULL(v)      ((nil != v && ![v isEqual:[NSNull null]] && ![[NSString stringWithFormat:@"%@", v] isEqualToString:@""]) ? YES : NO)
#define STRING_FROM_BOOL(b)     ((b) ? @"YES" : @"NO")
#define TRIM_STRING(s)          (STRING_NOT_NULL(s)) ? [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @""
#define STRINGS_MATCH(x,y) ([x compare:y options:NSCaseInsensitiveSearch] == NSOrderedSame) ? YES : NO

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]
#define methodNotImplemented() mustOverride()

// colors
//#define K_APP_COLOR_BLACK 0x333333
//#define K_APP_COLOR_BLUE 0x5688B2
//#define K_APP_COLOR_ORANGE 0xCC6600
//#define K_APP_COLOR_SILVER 0x777777

// fonts
#define K_APP_NAVBAR_FONT [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]
#define K_APP_MENU_FONT [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f]

// rest api
#define K_REST_BASE_HOST @"https://portal.audiofetch.com"
#define K_REST_BASE_URI [K_REST_BASE_HOST stringByAppendingString:@"/wp-content/plugins/waio/api"]
#define K_REST_ADS_URI [K_REST_BASE_URI stringByAppendingString:@"/ads/%@?wd=%f&ht=%f"]
#define K_REST_CUSTOMIZE_URI [K_REST_BASE_URI stringByAppendingString:@"/customize/%@?wd=%d&ht=%d&embed=1"]

// rest api -> reporting
#define K_REPORTING_ENABLED_PREF_KEY @"EnableReporting"
#define K_REST_TRACK_URI [K_REST_BASE_URI stringByAppendingString:@"/track/%@"]
#define K_DEFAULT_AD_SERIAL @"0" // TODO change this to a zero
#define K_DEFAULT_PING_INTERVAL 60.0 // send ping report every 25 seconds, while connected, or on channel change

// strings
#define K_APP_NAME @"AudioFetch"
#define K_APP_PHONE @"8444433824"
#define K_APP_URI @"audiofetch://"
#define K_APP_URL @"https://portal.audiofetch.com/"
#define K_APP_WIFI_MSG_BRANDED_SHORT NSLocalizedString(@"Connect to AudioFetch WiFi...", @"Connect to AudioFetch WiFi...")
#define K_APP_WIFI_MSG_BRANDED NSLocalizedString(@"Please connect to AudioFetch-Enabled WiFi.", @"Please connect to AudioFetch-Enabled WiFi.")
#define K_APP_CONTACT_ALERT NSLocalizedString(@"Would you like to contact BroadcastVision about advertising?", @"advertising?")
#define K_EMAIL_SUBJ NSLocalizedString(@"AudioFetch Feedback", @"AudioFetch Feedback")
#define K_EMAIL_BODY NSLocalizedString(@"We welcome your feedback.  Please be as specific as possible relative to your feedback and the service location.", @"feedback email")
#define K_EMAIL_CONFIRM NSLocalizedString(@"Your message has been sent.", @"Your message has been sent.")
#define K_EMAIL_AD_SUBJ NSLocalizedString(@"AudioFetch Sponsor Contact", @"AudioFetch Sponsor Contact")

// pref and api keys
#define K_PREFS_LAST_SYNC @"LastSyncDate"




//====================================================================================
#endif
