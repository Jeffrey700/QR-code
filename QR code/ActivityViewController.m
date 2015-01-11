//
//  ActivityViewController.m
//  QR code
//
//  Created by JunLee on 14/12/7.
//  Copyright (c) 2014年 斌. All rights reserved.
//

#import "ActivityViewController.h"
#import "AppDelegate.h"

@interface ActivityViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    AppDelegate* appDelegate;
}
@end

@implementation ActivityViewController

@synthesize datePicker;
@synthesize label;
@synthesize actionNum;
@synthesize inputActionNum;

- (void)viewDidLoad {
    [super viewDidLoad];
    inputActionNum.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 * 点击 “创建” 把活动信息 传送到数据库
 */
- (IBAction)onclick:(id)sender
{
   // appDelegate = [UIApplication sharedApplication].delegate;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDate * theDate = self.datePicker.date;
    NSLog(@"the date picked is:%@",[theDate descriptionWithLocale:[NSLocale currentLocale]]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSLog(@"the date formate is:%@",[dateFormatter stringFromDate:theDate]);
    self.label.text =[dateFormatter stringFromDate:theDate] ;
    self.actionNum.text = inputActionNum.text;
    
    
    NSString* url = @"http://1.lotuslove.sinaapp.com/addEvent.php";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.label.text,@"time",self.actionNum.text ,@"name",nil];
    // 使用AFHTTPRequestOperationManager发送POST请求
    [manager POST:url
                   parameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject){
                      NSLog(@"传活动成功：%@",responseObject);
                      }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"传活动名失败: %@", error);
     }];
    
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UITextViewDelegate
-(BOOL) textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
