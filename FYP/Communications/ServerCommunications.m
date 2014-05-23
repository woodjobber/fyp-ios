//
//  ServerCommunications.m
//  Find your Pet
//
//  Created by Sebastian Cancinos on 5/6/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//
// DEVELOPMENT
//#define kServerURL      @"http://ec2-54-215-131-112.us-west-1.compute.amazonaws.com/"
// PRODUCTION
  #define kServerURL      @"http://find-your-pet.herokuapp.com/"

#import "ServerCommunications.h" 
#import "Account.h"
#import "AFNetworking.h"

static ServerCommunications *sharedInstance = nil;

@interface ServerCommunications()

@property (nonatomic, strong) NSOperationQueue* priorityOperationQueue;

@end

@implementation ServerCommunications

@synthesize userInfo;

- (void) resetUserInfo
{
    userInfo = [[Account alloc] init];
}

- (void) setUserInfo: (Account*) info
{
    if(self.userInfo)
    {
        NSMutableDictionary* mInfo = [NSMutableDictionary dictionaryWithDictionary: [self.userInfo getData]];
        // Don't replace info with server_info, because I'd loose the password set on the account
        NSArray* keys = [[info getData] allKeys];

        for(NSString* k in keys)
        {
            [mInfo setValue:[info getInfoByName: k] forKey:k];
        }

        [self.userInfo setData:[NSDictionary dictionaryWithDictionary:mInfo]];
    }
    else
        userInfo = info;
}

+ (ServerCommunications*) getSharedInstance
{
    if(!sharedInstance)
    {
        sharedInstance = [[ServerCommunications alloc] init];
        sharedInstance.userInfo = [[Account alloc] init];
        sharedInstance.operationQueue = [[NSOperationQueue alloc] init];
        sharedInstance.priorityOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    return sharedInstance;
}

//http://stackoverflow.com/questions/6006823/creating-a-base-64-string-from-nsdata
+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}

- (void) sendJSONRequestToURL: (NSString*) path Data:(NSData*) data contentType: (NSString*) contentType Method: (NSString*) method usePriorityQueue:(BOOL)isPriority completion:(void (^)(NSDictionary* ))completion
{
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerURL,path]]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [theRequest setHTTPMethod:method];
    [theRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];

    if(data)
        [theRequest setValue:[NSString stringWithFormat:@"%i",[data length]] forHTTPHeaderField:@"Content-length"];
    
    if(self.userInfo)
    {
        NSString *authStr = nil;
        NSString *username,*password;
        
        username = [userInfo getInfoByName:@"username"];
        password =[userInfo getInfoByName:@"password"];
        if((username != nil) && (password != nil))
        {
            authStr = [NSString stringWithFormat:@"%@:%@", username, password];
        }
        else if([userInfo getInfoByName:@"authentication_token"])
        {
            authStr = [NSString stringWithFormat:@"%@:%@", [userInfo getInfoByName:@"authentication_token"], @"*****"];
        }
        
        if(authStr != nil)
        {
            NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
            NSString *authValue = [NSString stringWithFormat:@"Basic %@", [ServerCommunications base64forData:authData]];
            
            [theRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
        }
    }
    
    [theRequest setHTTPBody:data];
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:theRequest
                                                                                        success: ^(NSURLRequest* request, NSHTTPURLResponse* response, id JSON)
     {
         if(completion)
             completion(JSON);

     }
                                                                                        failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id JSON)
     {
         NSError *serError;
         NSDictionary* JSONData;
         NSString* alertText = @"";

         if([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
         {
             JSONData = [NSJSONSerialization JSONObjectWithData:[[error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&serError];
         }
         
         if(!JSONData)
         {
             alertText = [error localizedDescription];
             NSLog(@"Communication Error: %@ \nfor URL: %@" , alertText, [request.URL absoluteString]);
             
             if(error.code != -999)
             {
             
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle: @"Communication Error"
                                           message: alertText
                                           delegate: nil
                                           cancelButtonTitle:@"Close"
                                           otherButtonTitles:nil];
                     
                     [alert show];
                 });
             }
         }
         if(completion)
             completion(JSONData);
     } ];
    
    if(isPriority)
        [self.priorityOperationQueue addOperation:operation];
    else
        [self.operationQueue addOperation:operation];
}

- (void) sendJSONRequestToURL: (NSString*) path Data:(NSData*) data contentType: (NSString*) contentType Method: (NSString*) method completion:(void (^)(NSDictionary* ))completion
{
    [self sendJSONRequestToURL:path Data:data contentType:contentType Method:method usePriorityQueue:NO completion:completion];
}

- (void) sendJSONRequestToURL: (NSString*) path Data:(NSData*) data Method: (NSString*) method completion:(void (^)(NSDictionary* ))completion
{
    [self sendJSONRequestToURL: path Data:data contentType: @"application/json; charset=utf-8" Method:method completion:completion];

}

- (BOOL) isUserValidated
{
    NSNumber* identifier = [userInfo getInfoByName:@"id"];
    if(identifier!=nil)
    {
        if ((![userInfo getInfoByName:@"email"])
            && ([userInfo getInfoByName:@"external_auth_type"]))
        {
            return NO;
        }
    }
    
    return (identifier!=nil);
}

- (void) cancelOperations
{
    [self.operationQueue cancelAllOperations];
    [self.operationQueue waitUntilAllOperationsAreFinished];
}
@end
