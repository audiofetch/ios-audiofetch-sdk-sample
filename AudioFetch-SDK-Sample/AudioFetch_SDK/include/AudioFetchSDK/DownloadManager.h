//
//  DownloadManager.h
//
//  Created by Michael Honaker on 9/9/13.
//  Copyright (c) 2013 Beach Cities Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DownloadManager;
typedef void(^NetworkStatusChangedCompletionHandler)(DownloadManager * _Nonnull downloadManager);
typedef void(^NetworkReachableCompletionHandler)(BOOL isReachable);
typedef void(^DownloadManagerCompletionHandler)(_Nullable id json);

@protocol DownloadManagerAuthenticationDelegate <NSObject>
/**
 *  @return Returns an NSArray with a count of 2, with the first index being username, and second being password
 */
- (null_unspecified NSArray *)provideCredentials;
@end

@interface DownloadManager : NSObject {
    
@private
    NetworkReachableCompletionHandler netHandler;
}

@property (nonatomic) BOOL isReachable;
@property (nonatomic) BOOL isWifi;
@property (weak, null_unspecified) id <DownloadManagerAuthenticationDelegate> delegate;

+ (nonnull instancetype)sharedInstance;
+ (void)setCachePolicy:(NSURLRequestCachePolicy) policy;
+ (void)resetCachePolicy;

- (void)monitorNetworkStatus:(null_unspecified NetworkStatusChangedCompletionHandler) handler;
- (void)stopMonitoringNetworkStatus;
- (void)internetAvailableAtUrl:(nonnull NSString *) url WithHandler:(null_unspecified NetworkReachableCompletionHandler) handler;
- (void)downloadJSON:(nonnull NSString *) url CompletionHandler:(null_unspecified DownloadManagerCompletionHandler) handler;
- (void)postDownloadJSON:(nonnull NSString *) url
              WithParams:(nullable NSDictionary *) parameters
       CompletionHandler:(null_unspecified DownloadManagerCompletionHandler) handler;
@end
