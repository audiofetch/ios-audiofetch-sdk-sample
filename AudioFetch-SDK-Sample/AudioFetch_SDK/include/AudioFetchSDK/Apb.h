//
//  Apb.h
//  audiofetch
//
//  Copyright (c) 2015 Broadcast Vision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"

@interface Apb : NSObject
@property (strong, nonatomic) NSString* _Nonnull ipAddress;
@property (strong, nonatomic) NSString* _Nonnull serial;
@property (strong, nonatomic) NSString* _Nonnull json;

@property (readwrite) NSUInteger apbIndex;
@property (nonatomic) NSUInteger baseChannel;
@property (nonatomic) NSUInteger audioMode;
@property (nonatomic) BOOL initial;
@property (readonly) NSDictionary* _Nullable jsonDict;
@property (readonly) NSDictionary<NSString*, NSString*>* _Nullable channels;
@property (readonly) NSRange channelRange;
@property (readonly) NSArray<Channel*>* _Nonnull channelList;


+ (instancetype _Nonnull)abpWithHost:(NSString * _Nonnull)ip
                baseChannel:(NSUInteger)channel
                  audioMode:(NSUInteger)mode
                  isInitial:(BOOL)initial
               serialNumber:(NSString * _Nonnull)serial
                       json:(NSString * _Nonnull)json
                   apbIndex:(NSUInteger) index;

- (instancetype _Nonnull)initWithHost:(NSString * _Nonnull)ip
                 baseChannel:(NSUInteger)channel
                   audioMode:(NSUInteger)mode
                   isInitial:(BOOL)initial
                serialNumber:(NSString * _Nonnull)serial
                        json:(NSString * _Nonnull)json
                    apbIndex:(NSUInteger) index;

- (BOOL)containsChannel:(NSUInteger) channel;
- (NSString* _Nullable)nameForChannel:(NSUInteger) channel;
@end
