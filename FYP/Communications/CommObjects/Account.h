//
//  Account.h
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 5/6/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommObject.h"

@class  CLLocation;

typedef enum
{
    AccountAuthenticactionTypeTwitter,
    AccountAuthenticactionTypeFacebook,
    AccountAuthenticactionType_count
}AccountAuthenticactionTypeEnum;

@protocol AccountDelegateProtocol <CommObjectDelegateProtocol>

-(void) objectInitialized: (NSDictionary*) response;

@end

@interface Account : CommObject

- (void) initObject;
- (void) externalAuthenticationToken:(NSString*) token type:(AccountAuthenticactionTypeEnum) authType;
- (void) externalAuthenticationToken:(NSString*) token secretToken:(NSString*) secret type:(AccountAuthenticactionTypeEnum) authType;

- (void) resetPassword:(NSString*)email;

+ (void) checkUsername:(NSString*)username completion:(void (^)(bool )) completion;
+ (void) checkUsername:(NSString*)username email:(NSString*) email completion:(void (^)(NSDictionary* )) completion;
- (void) updateLocation:(CLLocation*)location;
- (void) setDevice:(NSString*) id token:(NSData*) token;
- (void) removeDevice:(NSString*) device_id;

+ (BOOL) isValidEmail:(NSString*) email;
@end
