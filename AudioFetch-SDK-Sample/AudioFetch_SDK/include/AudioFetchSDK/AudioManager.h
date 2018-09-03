//
//  AudioManager.h
//  audiofetch
//
//  Copyright © 2016 AudioFetch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Apb.h"

@interface AudioManager : NSObject <AVAudioPlayerDelegate>

/*====================================
// MARK: SINGLETON
//===================================*/


/**
 Singleton

 @return AudioManager
 */
+ (instancetype) sharedInstance;

/*====================================
// MARK: PUBLIC METHODS
//===================================*/

/**
 Start the audio

 @return YES if successful, NO otherwise
 */
- (BOOL)startAudio;

/**
 Start the audio on specified channel

 @param channel The channel, on which to start playing audio.
 @return YES if successful, NO otherwise
 */
- (BOOL)startAudioOn:(NSUInteger) channel;

/**
 Stops the audio
 */
- (void)stopAudio;

/**
 Deallocates the audio
 */
- (void)deallocAudio;

/**
 Play a demo track

 @param channel The demo channel
 */
- (void)playDemoTrack:(NSUInteger) channel;

/**
 Returns YES if the channel exists, NO otherwise

 @param channel The channel in question
 @return Returns YES if the channel exists, NO otherwise
 */
- (BOOL)hasChannel:(NSUInteger) channel;

/**
 Starts the audio check
 */
- (void)startAudioCheck;

/**
 Stops the audio check
 */
- (void)stopAudioCheck;

/**
 Audio check
 */
- (void)audioCheck;


/**
 Audio check timeout
 */
- (void)audioCheckTimeout;

/*====================================
// MARK: PUBLIC PROPERTIES
//===================================*/


/**
 Whether audio is playing, or not
 */
@property (readonly) BOOL isAudioPlaying;

/**
 Whether demo mode is enabled, or not
 */
@property(readwrite) BOOL demoModeEnabled;

/**
 Whether the audio session is being held, or not
 */
@property(readwrite) BOOL holdAudioSession;

/**
 Whether the single APB is an express device
 */
@property(readonly) BOOL isExpressDevice;

/**
 What the volume level currently is set at (between 0 and 1)
 */
@property(readwrite) float volume;

/**
 The currently selected channel
 */
@property(readwrite) NSUInteger currentChannel;

/**
 The apb that is currently being accessed or nil
 */
@property(readonly) Apb *currentApb;

/**
 The list of discovered Apbs or nil
 */
@property(readonly) NSArray *allApbs;

/**
 Should be 75 for TV audio, 150 for music
 */
@property(readwrite) NSInteger bufferLatencyMilliseconds;

@end
