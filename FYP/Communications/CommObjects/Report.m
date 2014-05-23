//
//  reports.m
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "Report.h"

@implementation Report

+ (NSString*) name
{
    return @"reports";
}

- (NSString*) name
{
    return [Report name];
}

+ (void) list:(void (^)(NSDictionary* ))completion
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@",[self name]] Data:nil Method:@"GET" completion:completion];

}

- (void) candidates:(void (^)(NSDictionary* ))completion
{
    [[ServerCommunications getSharedInstance] sendJSONRequestToURL:[NSString stringWithFormat:@"%@/%@/candidates",[self name],[self getInfoByName:@"id"]] Data:nil Method:@"GET" completion:completion];
}

@end
