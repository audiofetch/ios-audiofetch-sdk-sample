//
//  Apb.h
//  audiofetch
//
//  Copyright (c) 2015 Broadcast Vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Apb : NSObject
@property (strong, nonatomic) NSString *ipAddress;
@property (strong, nonatomic) NSString *serial;
@property (strong, nonatomic) NSString *json;

@property (readwrite) NSUInteger apbIndex;
@property (nonatomic) NSUInteger baseChannel;
@property (nonatomic) NSUInteger audioMode;
@property (nonatomic) BOOL initial;
@property (readonly) NSDictionary *jsonDict;
@property (readonly) NSDictionary *channels;
@property (readonly) NSRange channelRange;
@property (readonly) NSArray *channelList;


+ (instancetype)abpWithHost:(NSString *)ip
                baseChannel:(NSUInteger)channel
                  audioMode:(NSUInteger)mode
                  isInitial:(BOOL)initial
               serialNumber:(NSString *)serial
                       json:(NSString *)json
                   apbIndex:(NSUInteger) index;

- (instancetype)initWithHost:(NSString *)ip
                 baseChannel:(NSUInteger)channel
                   audioMode:(NSUInteger)mode
                   isInitial:(BOOL)initial
                serialNumber:(NSString *)serial
                        json:(NSString *)json
                    apbIndex:(NSUInteger) index;

- (BOOL)containsChannel:(NSUInteger) channel;
- (NSString *)nameForChannel:(NSUInteger) channel;
@end
