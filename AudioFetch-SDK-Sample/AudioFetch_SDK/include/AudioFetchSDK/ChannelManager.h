//
//  ChannelManager.h
//  audiofetch
//
//  Copyright © 2016 AudioFetch, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Apb.h"

@interface ChannelManager : NSObject

@property (class, readonly) ChannelManager* _Nonnull shared;

@property(strong, nonatomic) NSMutableArray<Apb*>* _Nullable apbs;
@property(strong, nonatomic) Apb* _Nullable currentApb;
@property(readonly) BOOL hasApbs;
@property(readwrite, atomic) NSInteger currentChannel;
@property(readonly) NSUInteger audioMode;

@property(readonly) NSArray* _Nullable fullChannelList;
@property(readonly) NSOrderedSet* _Nullable fullChannelSet;


- (void) resetChannelLists;
- (Apb* _Nullable)hostForChannel:(NSUInteger) channel;
- (BOOL)hasChannel:(NSUInteger) channel;

@end
