//
//  FYPAppDelegate.m
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "FYPAppDelegate.h"

@implementation FYPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) userLogedOut
{
//    [[ServerCommunications getSharedInstance].userInfo removeDevice:[OpenUDID value]];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [self.tabBarController setSelectedViewController:navHomeController];
//        NSArray* controllers =[NSArray arrayWithObjects:self.navHomeController, self.navFeedbackController,nil];
//        [controllers makeObjectsPerformSelector:@selector(popToRootViewControllerAnimated:) withObject:NO];
//        [self.tabBarController setViewControllers:controllers];
//    });
}

- (void) userLogedIn
{
//    if([[ServerCommunications getSharedInstance] isUserValidated])
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            self.findViewController = [[FindViewController alloc] initWithNibName:@"FindViewController" bundle:nil];
//            self.navFindController = [[UINavigationController alloc] initWithRootViewController:self.findViewController];
//            self.navFindController.navigationBarHidden =  NO;
//            [self.navFindController.navigationBar setTintColor:[UIColor darkGrayColor]];
//            
//            self.garagesViewController = [[GaragesViewController alloc] initWithNibName:@"GaragesViewController" bundle:nil];
//            self.navGaragesController = [[UINavigationController alloc] initWithRootViewController:self.garagesViewController];
//            self.navGaragesController.navigationBarHidden =  NO;
//            [self.navGaragesController.navigationBar setTintColor:[UIColor darkGrayColor]];
//            
//            self.accountViewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
//            self.navAccountController = [[UINavigationController alloc] initWithRootViewController:self.accountViewController];
//            self.navAccountController.navigationBarHidden =  NO;
//            [self.navAccountController.navigationBar setTintColor:[UIColor darkGrayColor]];
//            
//            NSArray* controllers =[NSArray arrayWithObjects:self.navFindController, self.navGaragesController,self.navHomeController, self.navFeedbackController, self.navAccountController,nil];
//            [controllers makeObjectsPerformSelector:@selector(popToRootViewControllerAnimated:) withObject:NO];
//            [self.tabBarController setViewControllers:controllers];
//            [self.tabBarController reloadInputViews];
//            
//            Account* user = [[ServerCommunications getSharedInstance] userInfo];
//            NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
//            
//            [person setValue:[user getInfoByName:@"username"] forKey:@"$first_name"];
//            [person setValue:[user getInfoByName:@"username"] forKey:@"username"];
//            [person setValue:[user getInfoByName:@"email"] forKey:@"$email"];
//            [person setValue:[user getInfoByName:@"location"] forKey:@"Location"];
//            
//            if(![user getInfoByName:@"external_auth_type"])
//                [person setValue:@"SMR" forKey:@"Auth_type"];
//            else
//                [person setValue:[user getInfoByName:@"external_auth_type"] forKey:@"Auth_type"];
//            
//            if([user getInfoByName:@"external_auth_type"])
//            {
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                
//                [userDefaults setObject:[user getInfoByName:@"authentication_token"]
//                                 forKey:kSavedAuthToken];
//                
//                [userDefaults synchronize];
//            }
//            
//            NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
//            [formatDate setTimeStyle:NSDateFormatterMediumStyle];
//            [formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString* strDate = [formatDate stringFromDate:[NSDate date]];
//            strDate = [strDate stringByReplacingOccurrencesOfString:@" " withString:@"T"];
//            
//            [person setValue:strDate forKey:@"Last Login"];
//            
//            [[Mixpanel sharedInstance].people set:person];
//            
//        });
//        
//        
//        if(self.notificationToken)
//            [[ServerCommunications getSharedInstance].userInfo setDevice:[OpenUDID value] token:self.notificationToken];
//    }
}


@end
