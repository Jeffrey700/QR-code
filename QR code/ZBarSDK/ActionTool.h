//
//  ActionTool.h
//  QR code
//
//  Created by JunLee on 15/1/4.
//  Copyright (c) 2015年 斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Action;

@interface ActionTool : NSObject

// 存储 活动信息
+(void)saveAction:(Action *)action;
+(Action *)action;
@end
