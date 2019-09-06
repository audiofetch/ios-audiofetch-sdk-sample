//
//  DownloadManager.h
//
//  Created by Michael Honaker on 9/9/13.
//  Copyright (c) 2013 Beach Cities Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DownloadManager;
typedef void(^NetworkStatusChangedCompletionHandler)(DownloadManager* _Nonnull downloadManager);
typedef void(^NetworkReachableCompletionHandler)(BOOL isReachable);
typedef void(^DownloadManagerCompletionHandler)(id _Nullable json);

@protocol DownloadManagerAuthenticationDelegate <NSObject>
/**
 *  @return Returns an NSArray with a count of 2, with the first index being username, and second being password
 */
- (NSArray* _Nonnull)provideCredentials;
@end

@interface DownloadManager : NSObject {
    
@private
    NetworkReachableCompletionHandler netHandler;
}

@property (class, readonly) DownloadManager* _Nonnull shared;

@property (nonatomic) BOOL isReachable;
@property (nonatomic) BOOL isWifi;
@property (weak) id <DownloadManagerAuthenticationDelegate> _Nullable delegate;

- (void)monitorNetworkStatus:(NetworkStatusChangedCompletionHandler _Nonnull) handler;
- (void)stopMonitoringNetworkStatus;
- (void)internetAvailableAtUrl:(NSString* _Nonnull) url WithHandler:(NetworkReachableCompletionHandler _Nonnull) handler;
- (void)downloadJSON:(NSString* _Nonnull) url CompletionHandler:(DownloadManagerCompletionHandler _Nonnull) handler;
- (void)postDownloadJSON:(NSString* _Nonnull) url
              WithParams:(NSDictionary* _Nullable) parameters
       CompletionHandler:(DownloadManagerCompletionHandler _Nonnull) handler;
@end
