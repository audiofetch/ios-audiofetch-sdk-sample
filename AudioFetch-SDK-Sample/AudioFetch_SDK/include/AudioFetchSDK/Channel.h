//
//  Channel.h
//  audiofetch
//
//  Copyright © 2016 AudioFetch, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
- (instancetype _Nonnull) init:(NSUInteger) aChannel
                      withName:(NSString * _Nonnull)aName;

- (instancetype _Nonnull) init:(NSUInteger) aChannel
                      apbIndex:(NSUInteger)index;

- (instancetype _Nonnull) init:(NSUInteger) aChannel
                      withName:(NSString *  _Nonnull)aName
                      apbIndex:(NSUInteger)index;


@property (readwrite, nonatomic) NSUInteger apbIndex;
@property (readwrite, nonatomic) NSUInteger channel;
@property (strong, nonatomic) NSString* _Nonnull name;
@end
