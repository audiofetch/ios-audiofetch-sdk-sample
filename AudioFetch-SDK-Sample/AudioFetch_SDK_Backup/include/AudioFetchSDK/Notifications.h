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
FRAMEWORK_EXTERN NSNotificationName _Nonnull const reloadNSUserDefaultsNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const apbDiscoveredNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const lowAudioNotification;

FRAMEWORK_EXTERN NSNotificationName _Nonnull const networkConnectionNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const demoModeToggledNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const diagnosticModeToggledNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const deviceDiscoveryFinishedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const audioBufferUpdateNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const emailSentNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const deviceDiscoveryFailedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const hardwareButtonVolumeNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const activeSerialNumberChangedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const volumeChangedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const playPressedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const pausePressedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const stopPressedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const forwardPressedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const backwardPressedNotification;
FRAMEWORK_EXTERN NSNotificationName _Nonnull const otherPressedNotification;

FRAMEWORK_EXTERN NSNotificationName _Nonnull const channelsLoadedNotification;
FRAMEWORK_EXTERN NSString*  _Nonnull const channelsLoadedNotificationChannelsKey;
FRAMEWORK_EXTERN NSString*  _Nonnull const channelsLoadedNotificationAudioModeKey;



// FONTS
FRAMEWORK_EXTERN NSString*  _Nonnull const K_APP_FONT_NAME;

// COLORS
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_BLACK;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_BLUE;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_ORANGE;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_SILVER;
FRAMEWORK_EXTERN NSInteger const K_APP_COLOR_GREEN;
