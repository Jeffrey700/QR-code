//
//  QDViewController.h
//  QR code
//
//  Created by JunLee on 14/12/18.
//  Copyright (c) 2014年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "EGORefreshTableHeaderView.h"
#import "ZBarSDK.h"

@interface QDViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,ZBarReaderDelegate>

{
    
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (retain, nonatomic) IBOutlet PullTableView *tableView;
- (IBAction)Scan:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UILabel *seleAction;

//开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;
@end
