//
//  CommObject.h
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 5/6/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCommunications.h"

@class CommObject;
@protocol CommObjectDelegateProtocol <NSObject>

@optional

- (void) getInfoReturned: (CommObject*) sender;
- (void) sendInfoReturned: (NSDictionary*)returned;
- (void) updateInfoReturned: (NSDictionary*)returned;
- (void) deleteObjectReturned: (CommObject*) sender;

@end

@interface CommObject : NSObject
{
    NSDictionary*   info;
}

@property (strong, nonatomic) id<CommObjectDelegateProtocol> delegate;

+ (NSString *)name;

- (id) initWithData:(NSDictionary*) data;
- (void) setData:(NSDictionary*) data;
- (NSDictionary*) getData;

- (id) getInfoByName:(NSString*) fieldName;

- (void) sendNewObject:(NSData*) data;
- (void) updateFromServer;
- (void) initObjectById:(NSInteger) identifier;
- (void) saveObjectInServer;
- (void) deleteObjectInServer;

+ (void) search:(NSDictionary*) searchData completion:(void (^)(NSDictionary* ))completion;
+ (void) search:(NSDictionary*) searchData name: (NSString*) name completion:(void (^)(NSDictionary* ))completion;

- (id) init;

- (void) getComments:(void (^)(NSDictionary*)) completion;
- (void) sendComment:(NSDictionary*) comment;

- (void) linkSpot:(NSInteger) spotID ;
- (void) unlinkSpot:(NSInteger) spotID;

@end
