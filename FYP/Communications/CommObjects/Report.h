//
//  reports.h
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "CommObject.h"

@interface Report : CommObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSString* animal_specie;
@property (nonatomic, strong) NSString* animal_race;
@property (nonatomic, strong) NSString* animal_size;
@property (nonatomic, strong) NSString* animal_color;
@property (nonatomic, assign) NSInteger animal_age;
@property (nonatomic, strong) NSString* animal_gender;
@property (nonatomic, strong) NSString* photoURL;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* place;
@property (nonatomic, strong) NSString* email;

+ (void) list:(void (^)(NSDictionary* ))completion;
+ (void) candidates:(void (^)(NSDictionary* ))completion;

@end
