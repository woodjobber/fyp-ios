//
//  Choices.h
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "CommObject.h"

@interface Choices : CommObject

+ (void) list:(void (^)(NSDictionary* ))completion;

@end
