//
//  ViewController.h
//  QR code
//
//  Created by 斌 on 12-8-2.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ViewController : UIViewController< ZBarReaderDelegate,UIAlertViewDelegate ,UIPickerViewDelegate,UIPickerViewDataSource>
{
    
        id dict;
    
}

@property (retain, nonatomic) IBOutlet UILabel *label;

@property (retain, nonatomic) IBOutlet UIImageView *imageview;
@property (retain, nonatomic) IBOutlet UITextField *text;
//@property (retain, nonatomic) IBOutlet UIPickerView *pickerView;
@property (retain, nonatomic) IBOutlet UIPickerView *pickerView;
@property (retain, nonatomic) IBOutlet UILabel *actionNum;
@property (nonatomic,strong)NSDictionary *pickerData;
@property (nonatomic,strong)NSArray *actions;
- (IBAction)button:(id)sender;
- (IBAction)button2:(id)sender;



@end
