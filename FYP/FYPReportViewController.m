//
//  FYPReportViewController.m
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "FYPReportViewController.h"

@interface FYPReportViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray* photos;

@property (nonatomic, strong) IBOutlet UIScrollView* scrllView;
@property (nonatomic, strong) IBOutlet UIButton* btnReport;
@property (nonatomic, strong) IBOutlet UITextView* txtDecription;

@end

@implementation FYPReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photos = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.scrllView setContentSize:CGSizeMake(self.view.frame.size.width, self.btnReport.frame.size.height + self.btnReport.frame.origin.y + 10)];
}

- (void) keyboardWasShown:(NSNotification*) notification
{
    CGSize keybSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self.scrllView setContentInset:UIEdgeInsetsMake(0,0, keybSize.height - 49,0)];
    
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= keybSize.height;
//    
//    if (!CGRectContainsPoint(aRect, self.txtDecription.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.txtDecription.frame.origin.y + self.txtDecription.frame.size.height - (keybSize.height));
        [self.scrllView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    [self.scrllView setContentInset:UIEdgeInsetsZero ];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath ];
    
    UIImage* image;
    if(indexPath.row == self.photos.count)
    {
        image = [UIImage imageNamed:@"camera-icon"];
    }
    else
    {
        image = [self.photos objectAtIndex:indexPath.row];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [cell addSubview:imageView];
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
