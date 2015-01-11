//
//  AppDelegate.h
//  QR code
//
//  Created by 斌 on 12-8-2.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"

@class ViewController;
@class ActivityViewController;
@class QDViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic,strong)ActivityViewController *activityViewController;
@property (nonatomic,strong)QDViewController *qdViewController;
@end
