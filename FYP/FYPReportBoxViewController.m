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
    

    [image setImageWithURL:[infoFeed objectForKey:@"imageURL"]
        placeholderImage:[UIImage imageNamed:@"tracks"]];

    if ([[infoFeed objectForKey:@"gender"] isEqualToString:@"male"])
        gender.image = [UIImage imageNamed:@"male"];
    else if ([[infoFeed objectForKey:@"gender"] isEqualToString:@"female"])
        gender.image = [UIImage imageNamed:@"femaleicon"];
    else
        gender.image = nil;
    
    if ([[infoFeed objectForKey:@"sightlost"] isEqualToString:@"sight"])
        gender.image = [UIImage imageNamed:@"sight_light"];
    else if ([[infoFeed objectForKey:@"searchlost"] isEqualToString:@"lost"])
        gender.image = [UIImage imageNamed:@"search_light"];
    else
        gender.image = nil;
    
}

@end
