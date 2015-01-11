//
//  QDViewController.m
//  QR code
//
//  Created by JunLee on 14/12/18.
//  Copyright (c) 2014年 斌. All rights reserved.
//
#import "JSONKit.h"
#import "QDViewController.h"
#import "AppDelegate.h"
#import "PullTableView.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "Action.h"

#import "YTKKeyValueStore.h"
#import "DBManager.h"
@interface QDViewController (){
    YTKKeyValueStore *store;
    NSString *tableName ;
    NSMutableDictionary *_listarr;  //定义一个存放数据的容器。 技术用
    NSArray *list ; //  计数 http的返回 条数
    NSInteger actionNum; //纪录当前活动数
}
@end

@implementation QDViewController

@synthesize tableView;
@synthesize label;
@synthesize seleAction;
- (void)viewDidLoad
{
    [super viewDidLoad];
    actionNum = 0;
    DBManager *dbManger = [[DBManager alloc] init];
    [dbManger connectionDatabaseName:@"qd.db"
                           tableName:@"actionlist"
                         column1Name:@"id"   column1Type:@"text"
                         column2Name:@"name" column2Type:@"text"
                         column3Name:nil     column3Type:nil
                         column4Name:nil     column4Type:nil];
  //  [self getActionList];
    NSLog(@"沙盒路径：%@",NSHomeDirectory());
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if(!self.tableView.pullTableIsRefreshing)
    {
        self.tableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable)
                   withObject:nil
                   afterDelay:3.0f];
    }
}

- (void)viewDidUnload
{
 [super viewDidUnload];

}

-(void)getActionList
{
    NSString *str=[NSString stringWithFormat:@"http://1.lotuslove.sinaapp.com/getEvent.php"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
          NSLog(@"JSON: %@", responseObject);
         list = responseObject;
         if(list.count > actionNum)
         {
    
             actionNum = list.count; //更新活动总数！
             //遍历数组list里的内容
             for (int i = 0; i<[list count]; i++)
             {
             //按数组中的索引取出对应的字典
             NSDictionary *listdic = [list objectAtIndex:i];
             
             //通过字典中的key取出对应value，并且强制转化为NSString类型
             NSString *name = (NSString *)[listdic objectForKey:@"name"];
             NSString* idnum = (NSString*)[listdic valueForKey:@"id"];
                 
             DBManager *dbManger = [[DBManager alloc] init];
             [dbManger connectionDatabaseName:@"qd.db"
                                    tableName:@"actionlist"
                                  column1Name:@"id" column1Type:@"text"
                                  column2Name:@"name" column2Type:@"text"
                                  column3Name:nil column3Type:nil
                                  column4Name:nil column4Type:nil];
             // 插入数据库
             [dbManger useDatabase:@"qd.db" insertIntoTableName:@"actionlist"
                            value1:idnum
                            value2:name
                            value3:nil
                            value4:nil];
             
            }
             
             NSLog(@"_listarr:%@",_listarr);
             [self.tableView reloadData]; //刷新 !!! tableView
         }
    
    }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"发生错误！%@",error);
     }];

    [[NSOperationQueue mainQueue] addOperation:operation];

}


#pragma mark - data

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:CellIdentifier];
    }
   
    NSString* actionid = [NSString stringWithFormat:@"%d", (indexPath.row+1)];
    NSLog(@"actionid: %@",actionid);
    DBManager *dbManger = [[DBManager alloc] init];
    NSArray *dbArray = [dbManger useDatabase:@"qd.db"
                          selectAllFromTable:@"actionlist"
                                whereColumn1:@"id" value1:actionid
                                     column2:nil
                                      value2:nil];
    NSLog(@"%@",dbArray);
    //按数组中的索引取出对应的字典
    NSDictionary *dbDiction = [dbArray objectAtIndex:0];
    //将要显示的数据赋值到cell上
   cell.textLabel.text =[dbDiction objectForKey:@"name"];
        return cell;
}
// 选中的cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    NSArray *keys = [_listarr allKeys];
    id key = [keys objectAtIndex:indexPath.row];
    seleAction.text = [_listarr objectForKey:key];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    [self getActionList];
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
     [self getActionList];
    self.tableView.pullTableIsLoadingMore = NO;
}
#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable)
               withObject:nil
               afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable)
               withObject:nil
               afterDelay:3.0f];
}


- (void)dealloc {
    [tableView release];
    [label release];
    [seleAction release];
    [super dealloc];
}
// 扫二维码
- (IBAction)Scan:(id)sender {
    
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

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
 //   imageview.image =
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
@end
