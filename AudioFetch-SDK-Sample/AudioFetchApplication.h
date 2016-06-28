//
//  AudioFetchApplication.h
//  audiofetch
//
//  Copyright © 2016 AudioFetch. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 For AudioFetch SDK, this should be the base UIApplication class,
 if you plan to expose the lock-screen, and control center audio player controls.
 
 Otherwise, in your own application you should forward the events, see 
 AudioFetch SDK documentation for details
 
 @todo Add ref to SDK documentation
 */
@interface AudioFetchApplication : UIApplication
+ (NSInteger)iOSVersion;
+ (NSInteger)iOSMinorVersion;
+ (NSInteger)iOSSubVersion;
@end
