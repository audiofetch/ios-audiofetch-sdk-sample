//
//  AudioManager.h
//  audiofetch
//
//  Copyright © 2016 AudioFetch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

#import "Apb.h"

@interface AudioManager : NSObject <AVAudioPlayerDelegate>

/*====================================
// MARK: SINGLETON
//===================================*/

+ (instancetype) sharedInstance;

/*====================================
// MARK: PUBLIC METHODS
//===================================*/

- (BOOL)startAudio;
- (void)stopAudio;
- (void)deallocAudio;

- (void)playDemoTrack:(NSUInteger) channel;

- (BOOL)hasChannel:(NSUInteger) channel;

- (void)startAudioCheck;
- (void)stopAudioCheck;
- (void)audioCheck;
- (void)audioCheckTimeout;

/*
- (void)sendStartReport;
- (void)sendPingReport;
- (void)sendAdsReport:(NSArray *) ads;
- (void)sendAdClickedReport:(int) adId;
- (void)deallocReporting;
*/

/*====================================
// MARK: PUBLIC PROPERTIES
//===================================*/

// TODO: finish commenting for SDK

@property (readonly) BOOL isAudioPlaying;
@property(readwrite) BOOL demoModeEnabled;
@property(readwrite) BOOL holdAudioSession;
@property(readonly) BOOL isExpressDevice;
@property(readwrite) float volume;

// comment or remove for SDK, dont expose buffer
@property(readonly) float* floatBuffer;
@property(readonly) UInt32 floatBufferSize;

/**
 The currently selected channel
 */
@property(readwrite) NSUInteger currentChannel;

// TODO: refactor out Apb reference

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
