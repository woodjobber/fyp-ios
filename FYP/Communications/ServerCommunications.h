//
//  ServerCommunications.h
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 5/6/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Account;

#define kSavedAuthToken @"prefAuthToken"
#define kSavedUserName  @"prefUserName"
#define kSavedPassword  @"prefPassword"

@interface ServerCommunications : NSObject

@property (nonatomic, strong) Account* userInfo;
@property (nonatomic, strong) NSOperationQueue* operationQueue;

- (void) sendJSONRequestToURL: (NSString*) path Data:(NSData*) data Method: (NSString*) method completion:(void (^)(NSDictionary* ))completion;
- (void) sendJSONRequestToURL: (NSString*) path Data:(NSData*) data contentType: (NSString*) contentType Method: (NSString*) method completion:(void (^)(NSDictionary* ))completion;
- (void) sendJSONRequestToURL: (NSString*) path Data:(NSData*) data contentType: (NSString*) contentType Method: (NSString*) method usePriorityQueue:(BOOL) isPriority completion:(void (^)(NSDictionary* ))completion;
- (void) cancelOperations;
    
+ (ServerCommunications *)getSharedInstance;

- (BOOL) isUserValidated;
- (void) resetUserInfo;
 
@end
