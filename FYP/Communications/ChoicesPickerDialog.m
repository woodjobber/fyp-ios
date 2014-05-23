//
//  DatePickerViewController.m
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 8/9/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import "ChoicesPickerDialog.h"
#import "FYPAppDelegate.h"

@interface ChoicesPickerDialog () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@end

@implementation ChoicesPickerDialog

- (id)init
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ChoicesPickerDialog" owner:nil options:nil];
	self = [topLevelObjects objectAtIndex:0];

    // Do any additional setup after loading the view from its nib.

    return self;
}

-(void) showPicker
{
    [self setFrame:[[UIScreen mainScreen] bounds]];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [self.container setFrame: CGRectMake(0, self.frame.size.height, self.container.frame.size.width, self.container.frame.size.height) ];
    [UIView animateWithDuration:0.5 animations:^(void){
        [self.container setFrame: CGRectMake(0, self.frame.size.height - self.container.frame.size.height, self.container.frame.size.width, self.container.frame.size.height) ];

    }];
}

- (void) hidePicker
{
    [UIView animateWithDuration:0.5 animations:^(void){
        [self.container setFrame: CGRectMake(0, self.frame.size.height, self.container.frame.size.width, self.container.frame.size.height) ];
    } completion:^(BOOL finished){
        if(finished)
            [self removeFromSuperview];
    }];
}

- (IBAction)cancel:(id)sender
{
    [self hidePicker];
}

- (IBAction)done:(id)sender
{
    if(self.delegate)
        [self.delegate ChoicesPickerDialog:self pickedOption:[self.options objectAtIndex:[self.picker selectedRowInComponent:0]]];
    
    [self hidePicker];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.options.count;
}

- (NSString* ) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.options objectAtIndex:row];
}

@end
