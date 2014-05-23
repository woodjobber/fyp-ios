//
//  FYPReportViewController.m
//  FYP
//
//  Created by Sebastian Cancinos on 5/23/14.
//  Copyright (c) 2014 inakathon. All rights reserved.
//

#import "FYPReportViewController.h"
#import "FYPAppDelegate.h"
#import "Choices.h"
#import "ChoicesPickerDialog.h"

@interface FYPReportViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ChoicesPickerDelegate>
{
    UIActionSheet   *photoActionSheet;
}

@property (nonatomic, strong) NSMutableArray* photos;
@property (nonatomic, strong) NSDictionary*   choices;


@property (nonatomic, strong) IBOutlet UIScrollView* scrllView;
@property (nonatomic, strong) IBOutlet UIButton* btnReport;
@property (nonatomic, strong) IBOutlet UITextView* txtDecription;

@property (nonatomic, strong) IBOutlet UITextField* fldSpecie;
@property (nonatomic, strong) IBOutlet UITextField* fldRace;
@property (nonatomic, strong) IBOutlet UITextField* fldSize;
@property (nonatomic, strong) IBOutlet UITextField* fldColor;
@property (nonatomic, strong) IBOutlet UITextField* fldAge;
@property (nonatomic, strong) IBOutlet UITextField* fldGender;

@property (nonatomic, strong) IBOutlet UIButton* btnSpecie;
@property (nonatomic, strong) IBOutlet UIButton* btnRace;
@property (nonatomic, strong) IBOutlet UIButton* btnSize;
@property (nonatomic, strong) IBOutlet UIButton* btnColor;
@property (nonatomic, strong) IBOutlet UIButton* btnAge;
@property (nonatomic, strong) IBOutlet UIButton* btnGender;

@property (nonatomic, strong) IBOutlet UISegmentedControl* reportKind ;
@property (nonatomic, strong) IBOutlet UICollectionView*   photosCollection;

typedef enum
{
    PhotoOptions_Camera,
    PhotoOptions_Gallery,
    PhotoOptions_count
}PhotoOptionsEnum;

typedef enum
{
    PickerOption_Specie,
    PickerOption_Race,
    PickerOption_Size,
    PickerOption_Color,
    PickerOption_Age,
    PickerOption_Gender,
    PickerOption_count
}PickerOptions;

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
    
    UITapGestureRecognizer *hideRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.view addGestureRecognizer:hideRecognizer];

    [self.scrllView setContentSize:CGSizeMake(self.view.frame.size.width, self.btnReport.frame.size.height + self.btnReport.frame.origin.y + 10)];
    
    [Choices list:^(NSDictionary *dic) {
        self.choices = dic;
    }];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)recognizer {
	[self.view endEditing:YES];
}

- (void) keyboardWasShown:(NSNotification*) notification
{
    CGSize keybSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self.scrllView setContentInset:UIEdgeInsetsMake(0,0, keybSize.height - 49,0)];
    
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
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setFrame:cell.bounds];
    [cell addSubview:imageView];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.photos.count)
    {
        photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture",@"Choose from library", nil];
        
        [photoActionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    switch (buttonIndex) {
        case PhotoOptions_Camera:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
            
        case PhotoOptions_Gallery:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        default:
            return;
            break;
    }
    
    imagePicker.delegate = self;
    imagePicker.title = @"";
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
	UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
	if(!image) {
		image = [info objectForKey:UIImagePickerControllerOriginalImage];
	}
    
    [self.photos addObject:image];
    [self.photosCollection reloadData];
}

- (IBAction)showOptions:(id)sender
{
    NSArray* options;
    PickerOptions tag;
    
    if(sender == self.btnSpecie)
    {
        NSDictionary* species =[self.choices objectForKey:@"species"];
        options = [species allKeys];
        
        tag = PickerOption_Specie;
    }
    else if(sender == self.btnRace)
    {
        if(self.fldSpecie.text.length > 0)
        {
            NSDictionary* species =[self.choices objectForKey:@"species"];
            options = [species objectForKey:self.fldSpecie.text];
            tag= PickerOption_Race;
        }
        else
            return;
    }
    else if(sender == self.btnSize)
    {
        options = [self.choices objectForKey:@"size"];
        tag= PickerOption_Size;
    }
    else if(sender == self.btnColor)
    {
        options = [self.choices objectForKey:@"color"];
        tag= PickerOption_Color;

    }
    else if(sender == self.btnAge)
    {
        options = [self.choices objectForKey:@"age"];
        tag= PickerOption_Age;

    }
    else if(sender == self.btnGender)
    {
        options = [self.choices objectForKey:@"sex"];
        tag= PickerOption_Gender;
    }
    ChoicesPickerDialog *picker = [[ChoicesPickerDialog alloc] init];
    [picker setOptions:options];
    [picker setDelegate:self];
    [picker setTag: tag];

    [picker showPicker];
    
}

- (void) ChoicesPickerDialog:(ChoicesPickerDialog *)picker pickedOption:(NSString *)selected
{
    UITextField* fld;
    
    switch (picker.tag) {
        case PickerOption_Specie:
            fld = self.fldSpecie;
            break;
            
        case PickerOption_Race:
            fld = self.fldRace;
            break;
            
        case PickerOption_Color:
            fld = self.fldColor;
            break;
            
        case PickerOption_Size:
            fld = self.fldSize;
            break;
            
        case PickerOption_Age:
            fld = self.fldAge;
            break;
            
        case PickerOption_Gender:
            fld = self.fldGender;
            break;
            
        default:
            break;
    }
    
    [fld setText:selected];
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
