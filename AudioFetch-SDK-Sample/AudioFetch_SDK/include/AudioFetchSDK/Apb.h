//
//  Apb.h
//  audiofetch
//
//  Copyright (c) 2015 Broadcast Vision. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "afetch_framework_extern.h"

AFETCH_FRAMEWORK_EXTERN NSInteger const K_CLIENT_FLAG_UNSET;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_CLIENT_FLAG_NONE;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_CLIENT_FLAG_HAS_ADS;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_CLIENT_FLAG_HAS_CUSTOMIZATIONS;

AFETCH_FRAMEWORK_EXTERN NSInteger const K_ACE_BUFFER_SIZE_MUSIC;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_ACE_BUFFER_SIZE_MUSIC_OLD;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_ACE_BUFFER_SIZE_MUSIC_BOOST;
AFETCH_FRAMEWORK_EXTERN NSInteger const K_ACE_BUFFER_SIZE_TVAUDIO;

@interface Apb : NSObject
@property (strong, nonatomic) NSString *ipAddress;
@property (strong, nonatomic) NSString *serial;
@property (strong, nonatomic) NSString *json;
@property (readonly) BOOL isExpressDevice;
@property (readonly) BOOL isStereo;
@property (readonly) BOOL isMono;

@property (strong, nonatomic) NSDictionary * _Nonnull waioUsers;
@property (readwrite) NSUInteger apbIndex;
@property (nonatomic) NSUInteger baseChannel;
@property (nonatomic) NSUInteger audioMode;
@property (nonatomic) BOOL initial;
@property (readonly) NSDictionary *jsonDict;
@property (readonly) NSDictionary *channels;
@property (readonly) NSRange channelRange;
@property (readonly) NSArray *channelList;

@property (atomic) NSInteger aceSetting;
@property (readonly) NSInteger extractedAceSetting;

+ (BOOL) hasAds;
+ (BOOL) hasCustomizations;

+ (NSArray *) BUFFER_SIZES;
+ (NSInteger) clientFlags;
+ (void) setClientFlags:(NSInteger) cFlags;

+ (instancetype _Nonnull)abpWithHost:(NSString * _Nonnull)ip
                 baseChannel:(NSUInteger)channel
                   audioMode:(NSUInteger)mode
                   isInitial:(BOOL)initial
                serialNumber:(NSString * _Nonnull)serial
                        json:(NSString * _Nonnull)json
                    apbIndex:(NSUInteger) index
                   waioUsers:(NSDictionary * _Nonnull)users;

+ (instancetype)abpWithHost:(NSString *)ip
                baseChannel:(NSUInteger)channel
                  audioMode:(NSUInteger)mode
                  isInitial:(BOOL)initial
               serialNumber:(NSString *)serial
                       json:(NSString *)json
                   apbIndex:(NSUInteger) index
                  waioUsers:(NSDictionary * _Nonnull)users
                clientFlags:(NSInteger) cFlags
                 aceSetting:(NSInteger) ace;

- (instancetype)initWithHost:(NSString *)ip
                 baseChannel:(NSUInteger)channel
                   audioMode:(NSUInteger)mode
                   isInitial:(BOOL)initial
                serialNumber:(NSString *)serial
                        json:(NSString *)json
                    apbIndex:(NSUInteger) index
                   waioUsers:(NSDictionary * _Nonnull)users
                 clientFlags:(NSInteger) cFlags
                  aceSetting:(NSInteger) ace;

- (instancetype _Nonnull)initWithHost:(NSString * _Nonnull)ip
                 baseChannel:(NSUInteger)channel
                   audioMode:(NSUInteger)mode
                   isInitial:(BOOL)initial
                serialNumber:(NSString * _Nonnull)serial
                        json:(NSString * _Nonnull)json
                    apbIndex:(NSUInteger) index
                   waioUsers:(NSDictionary * _Nonnull)users;

- (BOOL)containsChannel:(NSUInteger) channel;
- (NSString *)nameForChannel:(NSUInteger) channel;

- (NSInteger)getAceBufferSetting:(NSInteger) userSelectedBufferMs;
@end
