//
//  Choices.m
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "Choices.h"

@implementation Choices


+ (NSString*) name
{
    return @"choices";
}

- (NSString*) name
{
    return [Choices name];
}

+ (void) list:(void (^)(NSDictionary* ))completion
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@",[self name]] Data:nil Method:@"GET" completion:completion];
}


@end
