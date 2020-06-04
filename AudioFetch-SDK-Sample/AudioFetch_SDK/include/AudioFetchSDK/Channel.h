//
//  Channel.h
//  audiofetch
//
//  Copyright © 2016 AudioFetch, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
- (instancetype) init:(NSUInteger) aChannel withName:(NSString *)aName;
- (instancetype) init:(NSUInteger) aChannel apbIndex:(NSUInteger)index;
- (instancetype) init:(NSUInteger) aChannel withName:(NSString *)aName apbIndex:(NSUInteger)index;


@property (readwrite, nonatomic) NSUInteger apbIndex;
@property (readwrite, nonatomic) NSUInteger channel;
@property (strong, nonatomic) NSString *name;

@property (readonly) BOOL hasCustomIcon;
@property (readonly, nullable) NSURL *customIcon;
@end
