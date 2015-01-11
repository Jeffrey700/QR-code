//
//  ActivityViewController.h
//  QR code
//
//  Created by JunLee on 14/12/7.
//  Copyright (c) 2014年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UILabel *label;
- (IBAction)onclick:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *actionNum;
@property (retain, nonatomic) IBOutlet UITextField *inputActionNum;
@end
