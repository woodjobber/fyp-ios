//
//  FYPReportBoxViewController.m
//  FYP
//
//  Created by Inaka on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "FYPReportBoxTableCell.h"

@interface FYPReportBoxTableCell()
{
    
}

@property (nonatomic, strong) IBOutlet UILabel* fldPlace;
@property (nonatomic, strong) IBOutlet UILabel* fldDate;
@property (nonatomic, strong) IBOutlet UILabel* fldName;
@property (nonatomic, strong) IBOutlet UIImageView* reportImage;
@property (nonatomic, strong) IBOutlet UIImageView* imgGender;
@property (nonatomic, strong) IBOutlet UIImageView* imgSearchLost;

@end

@implementation FYPReportBoxTableCell

@synthesize place;
@synthesize date;
@synthesize name;
@synthesize image;
@synthesize gender;
@synthesize searchOrLost;

-(void)setProperties:(NSDictionary*)infoFeed{
    place = [infoFeed objectForKey: @"place"];
    date = [infoFeed objectForKey: @"created_at"];
    name = [infoFeed objectForKey: @"name"];

    [self.reportImage setImageWithURL:[infoFeed objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"tracks"]];

    if ([[infoFeed objectForKey:@"sex"] isEqualToString:@"male"])
        gender = [UIImage imageNamed:@"male"];
    else if ([[infoFeed objectForKey:@"sex"] isEqualToString:@"female"])
        gender = [UIImage imageNamed:@"femaleicon"];
    else
        gender = nil;
    
    if ([[infoFeed objectForKey:@"type"] isEqualToString:@"sighting"])
        searchOrLost = [UIImage imageNamed:@"sight_light"];
    else if ([[infoFeed objectForKey:@"type"] isEqualToString:@"report"])
        searchOrLost = [UIImage imageNamed:@"search_light"];
    else
        searchOrLost = nil;

    [self.imgGender setImage:self.gender];
    [self.imgSearchLost setImage:self.searchOrLost];
    
    NSLog(@"%@",infoFeed);
    if(![self.name isKindOfClass:[NSNull class]])
        [self.fldName setText:self.name];
    if(![self.place isKindOfClass:[NSNull class]])
        [self.fldPlace setText:self.place];
    if(![self.date isKindOfClass:[NSNull class]])
        [self.fldDate setText:self.date];
    
}

+ (FYPReportBoxTableCell*) instance
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FYPReportBoxTableCell" owner:nil options:nil];
	return [topLevelObjects objectAtIndex:0];
}
@end
