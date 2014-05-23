//
//  ChoicesPickerDialog.h
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 8/9/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChoicesPickerDialog;

@protocol ChoicesPickerDelegate <NSObject>

- (void) ChoicesPickerDialog:(ChoicesPickerDialog*) picker pickedOption: (NSString*) selected;

@end

@interface ChoicesPickerDialog : UIView

@property (nonatomic, strong) NSArray*                  options;
@property (nonatomic, assign) NSInteger                 tag;
@property (nonatomic, strong) id<ChoicesPickerDelegate> delegate;

-(void) showPicker;
@end
