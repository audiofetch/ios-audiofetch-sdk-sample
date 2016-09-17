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

// NOTIFICATIONS
FRAMEWORK_EXTERN NSNotificationName const reloadNSUserDefaultsNotification;
FRAMEWORK_EXTERN NSNotificationName const apbDiscoveredNotification;
FRAMEWORK_EXTERN NSNotificationName const lowAudioNotification;

FRAMEWORK_EXTERN NSNotificationName const networkConnectionNotification;
FRAMEWORK_EXTERN NSNotificationName const demoModeToggledNotification;
FRAMEWORK_EXTERN NSNotificationName const diagnosticModeToggledNotification;
FRAMEWORK_EXTERN NSNotificationName const deviceDiscoveryFinishedNotification;
FRAMEWORK_EXTERN NSNotificationName const audioBufferUpdateNotification;
FRAMEWORK_EXTERN NSNotificationName const emailSentNotification;
FRAMEWORK_EXTERN NSNotificationName const deviceDiscoveryFailedNotification;
FRAMEWORK_EXTERN NSNotificationName const hardwareButtonVolumeNotification;
FRAMEWORK_EXTERN NSNotificationName const activeSerialNumberChangedNotification;
FRAMEWORK_EXTERN NSNotificationName const volumeChangedNotification;
FRAMEWORK_EXTERN NSNotificationName const playPressedNotification;
FRAMEWORK_EXTERN NSNotificationName const pausePressedNotification;
FRAMEWORK_EXTERN NSNotificationName const stopPressedNotification;
FRAMEWORK_EXTERN NSNotificationName const forwardPressedNotification;
FRAMEWORK_EXTERN NSNotificationName const backwardPressedNotification;
FRAMEWORK_EXTERN NSNotificationName const otherPressedNotification;

FRAMEWORK_EXTERN NSNotificationName const channelsLoadedNotification;
FRAMEWORK_EXTERN NSString *const channelsLoadedNotificationChannelsKey;
FRAMEWORK_EXTERN NSString *const channelsLoadedNotificationAudioModeKey;



// FONTS
FRAMEWORK_EXTERN NSString *const K_APP_FONT_NAME;

// COLORS
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_BLACK;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_BLUE;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_ORANGE;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_SILVER;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_GREEN;
