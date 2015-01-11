//
//  ViewController.m
//  QR code
//
//  Created by 斌 on 12-8-2.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import "ViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "AppDelegate.h"
@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>
@end

@implementation ViewController
@synthesize imageview;
@synthesize text;
@synthesize label;
@synthesize pickerData;  // plist的数据
@synthesize actions;
@synthesize actionNum; // 用来显示 活动编号的 label
@synthesize pickerView;

- (void)dealloc
{
    [label release];
    [imageview release];
    [text release];
    [pickerData release];
    [actionNum release];
    [pickerView release];
    [actions release];
    [pickerView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    

    NSString *str=[NSString stringWithFormat:@"http://1.lotuslove.sinaapp.com/getEvent.php"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                  NSLog(@"JSON: %@", responseObject);
                                  NSString *html = operation.responseString;
                                  NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        
                                   dict=[NSJSONSerialization  JSONObjectWithData:data
                                                                           options:0
                                                                             error:nil];
                                  NSLog(@"获取到的数据为：%@",dict);
                                  }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"发生错误！%@",error);
    }];
    
     [[NSOperationQueue mainQueue] addOperation:operation];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:operation];


//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *plistPath = [bundle pathForResource:@"action"
//                                           ofType:@"plist"];
//    //获取属性列表文件中的全部数据
//    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
//    self.pickerData = dict;
//    self.actions = [self.pickerData allKeys]; // 字典放入数组
//    
    text.delegate = self;
    pickerView.dataSource =self;
    pickerView.delegate  = self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.pickerData = dict;
    self.actions = [self.pickerData allKeys]; // 字典放入数组
    
    text.delegate = self;
    pickerView.dataSource =self;
    pickerView.delegate  = self;

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)button:(id)sender {
    /*扫描二维码部分：
    导入ZBarSDK文件并引入一下框架
    AVFoundation.framework
    CoreMedia.framework
    CoreVideo.framework
    QuartzCore.framework
    libiconv.dylib
    引入头文件#import “ZBarSDK.h” 即可使用
    当找到条形码时，会执行代理方法
    
    - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
    
    最后读取并显示了条形码的图片和内容。*/
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader
                       animated:YES
                     completion:nil];
    [reader release];
}
/*
 * 生成
 */
- (IBAction)button2:(id)sender {
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
	imageview.image = [QRCodeGenerator qrImageForString:text.text
                                              imageSize:imageview.bounds.size.width];
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    imageview.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissViewControllerAnimated:YES
                               completion:nil];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    label.text =  symbol.data ;
    
    if ([predicate evaluateWithObject:label.text]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"It will use the browser to this URL。"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=1;
        [alert show];
        [alert release];
        
        
        
    }
    else if([ssidPre evaluateWithObject:label.text]){

        NSArray *arr = [label.text componentsSeparatedByString:@";"];
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        label.text=
        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:label.text
                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=2;
        [alert show];
        [alert release];
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1]; 
        
        
    }
}

/*
   关闭 键盘
 */
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UITextViewDelegate
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -UIPickerviewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
   return self.actions.count;
}

#pragma mark - PickerView Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [actions objectAtIndex:row] ;
}

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{

        NSString *seletedAction = [actions objectAtIndex:row];
        [self.pickerData objectForKey:seletedAction];
    NSLog(@"%@",[actions objectAtIndex:row]);
    [self.pickerView reloadComponent:0];
}


@end
