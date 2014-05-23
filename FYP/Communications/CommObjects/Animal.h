//
//  Animal.h
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "CommObject.h"

@interface Animal : CommObject

@property (nonatomic, strong) NSString* specie;
@property (nonatomic, strong) NSString* race;
@property (nonatomic, strong) NSString* size;
@property (nonatomic, strong) NSString* color;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString* gender;

@end
