//
//  FYPFirstViewController.m
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "FYPHomeViewController.h"
#import "Sightings.h"
#import "FYPReportBoxTableCell.h"

@interface FYPHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property  (nonatomic, strong) NSArray* objects;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UISegmentedControl* modeControl;
@end

@implementation FYPHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.objects = [[NSArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateList:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self updateList:nil];
}

- (IBAction) updateList:(id)sender
{
    switch (self.modeControl.selectedSegmentIndex) {
        case 0:
        {
            [Report list:^(NSDictionary * dic) {
                
                self.objects = dic;
                [self.tableView  reloadData];
            }];
        }
        break;

        case 1:
        default:
        {
            [Sightings list:^(NSDictionary * dic) {
                
                self.objects = dic;
                [self.tableView  reloadData];
            }];
        }
        break;
    };
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320.;    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYPReportBoxTableCell* tableCell = (FYPReportBoxTableCell*) [tableView dequeueReusableCellWithIdentifier:@"ReportCell"];
    if(!tableCell)
    {
        tableCell = [FYPReportBoxTableCell instance];
    }
    
    [tableCell setProperties:[self.objects objectAtIndex:indexPath.row]];
    
    return tableCell;
}

@end
