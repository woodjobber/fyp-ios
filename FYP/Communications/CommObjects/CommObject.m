//
//  CommObject.m
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 5/6/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import "CommObject.h"

@implementation CommObject

@synthesize delegate;
//Must be overriden
- (NSString*) name
{
    return @"nil";
}

+ (NSString *)name {
	return [[self class] name];
}

- (id) getInfoByName:(NSString*) fieldName
{
    id ret  =[info objectForKey:fieldName];
    
    if(ret == nil)
        return nil;
    
    if([ret isKindOfClass:[NSNull class]])
        return nil;
    
    if([ret isKindOfClass:[NSString class]])
    {
        if([((NSString*)ret) isEqualToString:@"<null>"])
        {
            return nil;
        }
    }
    
    return ret;
}

- (NSDictionary*) getData
{
    return info;
}

-(void) setData:(NSDictionary*) data
{
    info = data;
}

-(id) init
{
    if(!self)
        self = [super init];
    
    info = nil;
    
    return self;
}

- (id) initWithData:(NSDictionary*) data
{
    if(!self)
        self = [super init];
    
    info = data;
    return self;
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
         if([server_info objectForKey:@"errors"] == nil)
             info = server_info;

         if([self.delegate respondsToSelector:@selector(sendInfoReturned:)] )
         {
             [self.delegate performSelector:@selector(sendInfoReturned:) withObject:server_info];
         }
     }];
}

- (void) updateFromServer
{
    [self initObjectById:[((NSNumber*)[self getInfoByName:@"id"]) integerValue]];
}

- (void) initObjectById:(NSInteger) identifier
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/%d.json",[self name],identifier] Data:nil contentType: @"application/json; charset=utf-8" Method:@"GET" usePriorityQueue:YES completion:^(NSDictionary* server_info)
     {
         if(server_info)
         {
             info = server_info;
             
             if([self.delegate respondsToSelector:@selector(getInfoReturned:)] )
             {
                 [self.delegate performSelector:@selector(getInfoReturned:) withObject:self];
             }
         }
     }];
}

- (void) saveObjectInServer
{
    NSNumber* identifier = [info objectForKey:@"id"];
    if (([identifier isKindOfClass: [NSNull class]]) || (identifier == nil))
    {
       [self sendNewObject:nil];
        return;
    }
    NSError* error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];

    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/%@.json",[self name],[info objectForKey:@"id"]] Data:data Method:@"PUT" completion:^(NSDictionary* server_info)
     {
         if([self.delegate respondsToSelector:@selector(sendInfoReturned:)] )
         {
             [self.delegate performSelector:@selector(sendInfoReturned:) withObject:server_info withObject:self];
         }
     }];
}

- (void) deleteObjectInServer
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/%@.json",[self name],[info objectForKey:@"id"]] Data:nil Method:@"DELETE" completion:^(NSDictionary* server_info)
     {
         if([self.delegate respondsToSelector:@selector(deleteObjectReturned:)])
             [self.delegate performSelector:@selector(deleteObjectReturned:) withObject:self];
     }];
}

+ (void) search:(NSDictionary*) searchData name: (NSString*) name completion:(void (^)(NSDictionary* ))completion
{
    NSString* url = [NSString stringWithFormat:@"search/%@.json",name];
    NSString* separator = @"?";
    
    for(NSString* key in searchData.allKeys)
    {
        if(![[searchData objectForKey:key] isKindOfClass:[NSNull class]])
        {
            url = [url stringByAppendingFormat:@"%@%@=%@",separator,key, [searchData objectForKey:key] ];

            if([separator isEqualToString:@"?"])
                separator = @"&";
        }
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:url Data:nil Method:@"GET" completion:completion];
}

+ (void) search:(NSDictionary*) searchData  completion:(void (^)(NSDictionary* ))completion
{
    return [self search:searchData name:[self name] completion:completion];
}

- (void) getComments:(void (^)(NSDictionary*)) completion
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/%@/comments.json",[self name],[info objectForKey:@"id"]] Data:nil Method:@"GET" completion:completion];

}

- (void) sendComment:(NSDictionary*) comment
{
    NSError* error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:comment options:0 error:&error];

    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/%@/comments.json",[self name],[info objectForKey:@"id"]] Data:data Method:@"POST" completion:^(NSDictionary* server_info)
     {
         if([self.delegate respondsToSelector:@selector(updateInfoReturned:)] )
             [self.delegate performSelector:@selector(updateInfoReturned:) withObject:server_info];
     }];
}

- (void) linkSpot:(NSInteger) spotID
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/%@/spots/%d/add_spot.json",[self name],[info objectForKey:@"id"],spotID] Data:nil Method:@"POST" completion:^(NSDictionary* server_info)
     {
         if([self.delegate respondsToSelector:@selector(updateInfoReturned:)] )
             [self.delegate performSelector:@selector(updateInfoReturned:) withObject:server_info];
     }]; 
}

- (void) unlinkSpot:(NSInteger) spotID
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/%@/spots/%d/remove_spot.json",[self name],[info objectForKey:@"id"],spotID] Data:nil Method:@"POST" completion:^(NSDictionary* server_info)
     {
         if([self.delegate respondsToSelector:@selector(updateInfoReturned:)] )
             [self.delegate performSelector:@selector(updateInfoReturned:) withObject:server_info];
     }];
}

@end
