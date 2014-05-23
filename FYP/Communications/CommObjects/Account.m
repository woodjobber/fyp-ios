//
//  Account.m
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 5/6/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import "Account.h"
#import <CoreLocation/CoreLocation.h>

@implementation Account

+ (NSString*) name
{
    return @"account";
}

- (NSString*) name
{
    return [Account name];
}

- (void) resetPassword:(NSString*)email
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:email forKey:@"email"];
    
    NSError* error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/reset_password.json",[self name]] Data:data Method:@"POST" completion:^(NSDictionary* server_info)
     {
         if([self.delegate respondsToSelector:@selector(sendInfoReturned:)] )
         {
             [self.delegate performSelector:@selector(sendInfoReturned:) withObject:server_info ];
         }
     }];
}

- (NSString*)stringWithDeviceToken:(NSData*)deviceToken {
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy];
}

- (void) setDevice:(NSString*) device_id token:(NSData*) token;
{
    NSString* t = [self stringWithDeviceToken:token];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:device_id forKey:@"device_uuid"];
    [dic setObject:t forKey:@"token"];
    
    NSError* error; 
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:@"devices.json" Data:data contentType: @"application/json; charset=utf-8" Method:@"POST" usePriorityQueue:YES completion:^(NSDictionary* server_info){}];
}

- (void) removeDevice:(NSString*) device_id{
    
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"devices/%@",device_id] Data:nil contentType: @"application/json; charset=utf-8" Method:@"DELETE" usePriorityQueue:YES completion:^(NSDictionary* server_info){}];
}

- (void) initObject
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@.json",[self name]] Data:nil Method:@"GET" completion:^(NSDictionary* server_info)
     {
         if([server_info objectForKey:@"error"] == nil)
         {
             // Don't replace info with server_info, because I'd loose the password set on the account
             NSArray* keys = [server_info allKeys];
             
             for(NSString* k in keys)
             {
                 [info setValue:[server_info objectForKey:k] forKey:k];
             }
             
             if([[UIApplication sharedApplication].delegate respondsToSelector:@selector(userLogedIn)] )
                 [[UIApplication sharedApplication].delegate performSelector:@selector(userLogedIn)];
         }
         
         if([self.delegate respondsToSelector:@selector(objectInitialized:)] )
         {
             [self.delegate performSelector:@selector(objectInitialized:) withObject:server_info withObject:self];
         }
     }];
}

- (void) sendNewObject:(NSData*) data
{
    if(!data)
    {
        NSError* error;
        data = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
    }
    
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@.json",[self name]] Data:data Method:@"POST" completion:^(NSDictionary* server_info)
     {
         if(([server_info objectForKey:@"error"] == nil) && ([server_info objectForKey:@"errors"] == nil))
         {
             NSMutableDictionary* mInfo = [NSMutableDictionary dictionaryWithDictionary:info];
             // Don't replace info with server_info, because I'd loose the password set on the account
             NSArray* keys = [server_info allKeys];
             
             for(NSString* k in keys)
             {
                 [mInfo setValue:[server_info objectForKey:k] forKey:k];
             }
             
             info = [NSDictionary dictionaryWithDictionary:mInfo];
             
             if([[UIApplication sharedApplication].delegate respondsToSelector:@selector(userLogedIn)] )
                 [[UIApplication sharedApplication].delegate performSelector:@selector(userLogedIn)];
         }
         
         if([self.delegate respondsToSelector:@selector(sendInfoReturned:)] )
         {
             [self.delegate performSelector:@selector(sendInfoReturned:) withObject:server_info ];
         }
     }];
}

- (void) saveObjectInServer
{
    NSError* error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];

    NSNumber* identifier = [self getInfoByName:@"id"];
    if (!identifier)
    {
        [self sendNewObject:data];
        return;
    }
    
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@.json",[self name]] Data:data Method:@"PUT" completion:^(NSDictionary* server_info)
     {
         if([self.delegate respondsToSelector:@selector(sendInfoReturned:)] )
         {
             [self.delegate performSelector:@selector(sendInfoReturned:) withObject:server_info];
         }
     }];
}

- (void) externalAuthenticationToken:(NSString*) token type:(AccountAuthenticactionTypeEnum) authType
{
    [self externalAuthenticationToken:token secretToken:nil type:authType];
}

- (void) externalAuthenticationToken:(NSString*) token secretToken:(NSString*) secret type:(AccountAuthenticactionTypeEnum) authType
{
    NSString* strAuthType = nil;
    
    switch (authType) {
        case AccountAuthenticactionTypeFacebook:
            strAuthType = @"facebook";
            break;
            
        case AccountAuthenticactionTypeTwitter:
            strAuthType = @"twitter";
            break;
            
        default:
            break;
    }
    
    NSDictionary *dicData;
    
    if(secret)
    {
        dicData= [NSDictionary dictionaryWithObjectsAndKeys:
                  token,@"external_auth_token",
                  secret,@"external_auth_secret",
                  strAuthType, @"external_auth_type",
                  nil];
    }
    else
    {
        dicData= [NSDictionary dictionaryWithObjectsAndKeys:
                             token,@"external_auth_token",
                             strAuthType, @"external_auth_type",
                                       nil];
    }
    
    NSError* error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dicData options:0 error:&error];
    
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/authenticate_external.json",[self name]] Data:data Method:@"POST" completion:^(NSDictionary* server_info)
     {
         if([server_info objectForKey:@"error"] == nil)
         {
             NSMutableDictionary* mInfo = [NSMutableDictionary dictionaryWithDictionary:info];
             // Don't replace info with server_info, because I'd loose the password set on the account
             NSArray* keys = [server_info allKeys];
             
             for(NSString* k in keys)
             {
                 [mInfo setValue:[server_info objectForKey:k] forKey:k];
             }
             
             info = [NSDictionary dictionaryWithDictionary:mInfo];
             
             if (![[server_info objectForKey:@"email"] isKindOfClass:[NSNull class]])
             {
                 if([[UIApplication sharedApplication].delegate respondsToSelector:@selector(userLogedIn)] )
                     [[UIApplication sharedApplication].delegate performSelector:@selector(userLogedIn)];
             }
         }

         if([self.delegate respondsToSelector:@selector(objectInitialized:)] )
         {
             [self.delegate performSelector:@selector(objectInitialized:) withObject:server_info];
         }
     }];

}

- (void) updateLocation:(CLLocation*)location
{
    NSError *error;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@(location.coordinate.latitude),@"latitude",@(location.coordinate.longitude),@"longitude", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];

    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@.json",[self name]] Data:data contentType: @"application/json; charset=utf-8" Method:@"PUT" usePriorityQueue:YES  completion:^(NSDictionary* server_info){}];
}

+ (void) checkUsername:(NSString*)username completion:(void (^)(bool )) completion
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/verify_username.json?username=%@",[self name],username] Data:nil Method:@"GET" completion:^(NSDictionary* server_info)
     {
         BOOL isOK = NO;
         if(server_info)
         {
             isOK = YES;
         }
         else
             isOK = NO;
         
         completion(isOK);
     }];
}

+ (void) checkUsername:(NSString*)username email:(NSString*) email completion:(void (^)(NSDictionary* )) completion
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/verify_username_email.json?username=%@&email=%@",[self name],username,email] Data:nil Method:@"GET" completion:^(NSDictionary* server_info)
     {
         completion(server_info);
     }];
}

+ (BOOL) isValidEmail:(NSString *)email
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
