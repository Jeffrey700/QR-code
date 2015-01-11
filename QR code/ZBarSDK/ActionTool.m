//
//  ActionTool.m
//  QR code
//
//  Created by JunLee on 15/1/4.
//  Copyright (c) 2015年 斌. All rights reserved.
//

#import "ActionTool.h"
#define ActionFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject ]stringByAppendingPathComponent:@"action.data"]

@implementation ActionTool

// 存储 活动信息  相当于 set 和 get 函数
+(void)saveAction:(Action *)action{
    // 存储模型数据
    
    [NSKeyedArchiver archiveRootObject:action
                                toFile:ActionFile]; // 归档
}
+(Action *)action{
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:ActionFile];

}
@end
