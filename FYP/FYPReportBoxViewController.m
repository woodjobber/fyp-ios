//
//  FYPReportBoxViewController.m
//  FYP
//
//  Created by Inaka on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "FYPReportBoxViewController.h"

@implementation FYPReportBoxViewController

@synthesize place;
@synthesize date;
@synthesize name;
@synthesize image;
@synthesize gender;
@synthesize searchOrLost;

-(void)setProperties:(NSDictionary*)infoFeed{
    place = [infoFeed objectForKey: @"place"];
    date = [infoFeed objectForKey: @"date"];
    name = [infoFeed objectForKey: @"name"];
    image = [infoFeed objectForKey:@"image"];
    
    
}


@end
