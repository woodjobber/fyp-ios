//
//  MediaCache.h
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 5/28/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaCache : NSObject

+ (void) downloadImageFromPath:(NSString*) path completion:(void (^)(UIImage* ))completion;

@end
