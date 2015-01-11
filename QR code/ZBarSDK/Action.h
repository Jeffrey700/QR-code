//
//  Action.h
//  QR code
//
//  Created by JunLee on 15/1/4.
//  Copyright (c) 2015年 斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Action : NSObject
@property (nonatomic,copy) NSString * actionName;
@property (nonatomic,assign) long  idNum;


+(instancetype)actionWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
