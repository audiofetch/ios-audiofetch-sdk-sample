//
//  Notifications.h
//  audiofetch
//
//


#import <UIKit/UIKit.h>

#ifdef __cplusplus
#define FRAMEWORK_EXTERN      extern "C" __attribute__((visibility ("default")))
#else
#define FRAMEWORK_EXTERN      extern __attribute__((visibility ("default")))
#endif

// TODO: SDK rename all these to have the NOTIFY_ prefix and use uppercase
// TODO: SDK possibly standardize on the same events that Android app uses so SDK's will jive
// TODO: SDK consider using similar events for notificatons bubbled up to swift so that a common class object can be shared rather than random undefined objects
// TODO: SDK define these said event classes, as already defined by the java implementation

FRAMEWORK_EXTERN NSString *const reloadNSUserDefaultsNotification;
FRAMEWORK_EXTERN NSString *const apbDiscoveredNotification;
FRAMEWORK_EXTERN NSString *const lowAudioNotification;

FRAMEWORK_EXTERN NSString *const networkConnectionNotification;
FRAMEWORK_EXTERN NSString *const demoModeToggledNotification;
FRAMEWORK_EXTERN NSString *const diagnosticModeToggledNotification;
FRAMEWORK_EXTERN NSString *const deviceDiscoveryFinishedNotification;

FRAMEWORK_EXTERN NSString *const audioBufferUpdateNotification;

FRAMEWORK_EXTERN NSString *const emailSentNotification;

FRAMEWORK_EXTERN NSString *const deviceDiscoveryFailedNotification;
FRAMEWORK_EXTERN NSString *const channelsLoadedNotification;
FRAMEWORK_EXTERN NSString *const channelsLoadedNotificationChannelsKey;
FRAMEWORK_EXTERN NSString *const channelsLoadedNotificationAudioModeKey;



FRAMEWORK_EXTERN NSString *const hardwareButtonVolumeNotification;

FRAMEWORK_EXTERN NSString *const activeSerialNumberChangedNotification;


// TODO: REMOVE THESE AND RESTORE AS MACROS AND MAKE INTERNAL
FRAMEWORK_EXTERN NSString *const volumeChangedNotification;
FRAMEWORK_EXTERN NSString *const playPressedNotification;
FRAMEWORK_EXTERN NSString *const pausePressedNotification;
FRAMEWORK_EXTERN NSString *const stopPressedNotification;
FRAMEWORK_EXTERN NSString *const forwardPressedNotification;
FRAMEWORK_EXTERN NSString *const backwardPressedNotification;
FRAMEWORK_EXTERN NSString *const otherPressedNotification;





FRAMEWORK_EXTERN NSString *const K_APP_FONT_NAME;

FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_BLACK;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_BLUE;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_ORANGE;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_SILVER;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_GREEN;