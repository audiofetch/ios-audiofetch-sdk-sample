//
//  Notifications.h
//  audiofetch
//
//


#import <UIKit/UIKit.h>
#import "Constants.h"

// TODO: SDK rename all these to have the NOTIFY_ prefix and use uppercase
// TODO: SDK possibly standardize on the same events that Android app uses so SDK's will jive
// TODO: SDK consider using similar events for notificatons bubbled up to swift so that a common class object can be shared rather than random undefined objects
// TODO: SDK define these said event classes, as already defined by the java implementation

AFETCH_FRAMEWORK_EXTERN NSNotificationName const reloadNSUserDefaultsNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const apbDiscoveredNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const lowAudioNotification;

AFETCH_FRAMEWORK_EXTERN NSNotificationName const networkConnectionNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const demoModeToggledNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const diagnosticModeToggledNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const deviceDiscoveryFinishedNotification;

AFETCH_FRAMEWORK_EXTERN NSNotificationName const audioBufferUpdateNotification;

AFETCH_FRAMEWORK_EXTERN NSNotificationName const emailSentNotification;

AFETCH_FRAMEWORK_EXTERN NSNotificationName const deviceDiscoveryFailedNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const channelsLoadedNotification;
AFETCH_FRAMEWORK_EXTERN NSString *const channelsLoadedNotificationChannelsKey;
AFETCH_FRAMEWORK_EXTERN NSString *const channelsLoadedNotificationAudioModeKey;



AFETCH_FRAMEWORK_EXTERN NSNotificationName const hardwareButtonVolumeNotification;

AFETCH_FRAMEWORK_EXTERN NSNotificationName const activeSerialNumberChangedNotification;


// TODO: REMOVE THESE AND RESTORE AS MACROS AND MAKE INTERNAL
AFETCH_FRAMEWORK_EXTERN NSNotificationName const volumeChangedNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const playPressedNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const pausePressedNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const stopPressedNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const forwardPressedNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const backwardPressedNotification;
AFETCH_FRAMEWORK_EXTERN NSNotificationName const otherPressedNotification;





AFETCH_FRAMEWORK_EXTERN NSString *const K_APP_FONT_NAME;

AFETCH_FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_BLACK;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_BLUE;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_ORANGE;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_SILVER;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_GREEN;
