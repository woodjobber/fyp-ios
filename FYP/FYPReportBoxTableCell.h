//
//  FYPReportBoxViewController.h
//  FYP
//
//  Created by Inaka on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"

@interface FYPReportBoxTableCell : UITableViewCell

@property (nonatomic, strong) NSString * place;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) UIImage * gender;
@property (nonatomic, strong) UIImage * searchOrLost;

+ (FYPReportBoxTableCell* ) instance;
-(void)setProperties:(NSDictionary*)infoFeed;

@end
