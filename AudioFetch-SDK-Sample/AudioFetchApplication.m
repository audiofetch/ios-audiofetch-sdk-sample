//
//  AudioFetchApplication.m
//  audiofetch
//
//  Copyright © 2016 AudioFetch. All rights reserved.
//

#import "AudioFetchApplication.h"
#import "Notifications.h"

@implementation AudioFetchApplication

+ (NSInteger)iOSVersion {
    NSArray *versionName = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSInteger major = (versionName.count > 0) ? [[versionName objectAtIndex:0] integerValue] : 0;
    return major;
}

+ (NSInteger)iOSMinorVersion {
    NSArray *versionName = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSInteger minor = (versionName.count >= 1) ? [[versionName objectAtIndex:1] integerValue] : 0;
    return minor;
}

+ (NSInteger)iOSSubVersion {
    NSArray *versionName = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSInteger sub = (versionName.count >= 2) ? [[versionName objectAtIndex:2] integerValue] : 0;
    return sub;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self postNotificationWithName:playPressedNotification];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self postNotificationWithName:pausePressedNotification];
            break;
        case UIEventSubtypeRemoteControlStop:
            [self postNotificationWithName:stopPressedNotification];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self postNotificationWithName:forwardPressedNotification];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self postNotificationWithName:backwardPressedNotification];
            break;
//        case UIEventSubtypeRemoteControlBeginSeekingForward:
//            DLog(@"Begin seeking forward");
//            break;
//        case UIEventSubtypeRemoteControlTogglePlayPause:
//            DLog(@"Play pause toggled");
//            break;
//        case UIEventSubtypeRemoteControlBeginSeekingBackward:
//            DLog(@"Begin seeking back");
//            break;
        default:
            [self postNotificationWithName:otherPressedNotification];
            break;
    }
}

- (void)postNotificationWithName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

@end
