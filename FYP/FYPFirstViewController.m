//
//  FYPFirstViewController.m
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "FYPFirstViewController.h"

@interface FYPFirstViewController () <UITableViewDataSource, UITableViewDelegate>

@property  (nonatomic, strong) NSArray* objects;
@end

@implementation FYPFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.objects = [[NSArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
