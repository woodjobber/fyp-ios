//
//  reports.h
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "CommObject.h"
#import "Animal.h"

@interface Report : CommObject

@property (nonatomic, strong) Animal* animal;
@property (nonatomic, strong) NSString* photoURL;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* place;
@property (nonatomic, strong) NSString* contacto;


+ (void) list:(void (^)(NSDictionary* ))completion;

@end
