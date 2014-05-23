//
//  FYPAppDelegate.h
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) userLogedIn;
- (void) userLogedOut;

@end
