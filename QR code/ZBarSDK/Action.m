//
//  Action.m
//  QR code
//
//  Created by JunLee on 15/1/4.
//  Copyright (c) 2015年 斌. All rights reserved.
//

#import "Action.h"

@implementation Action

+(instancetype)actionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
     //   [self setValuesForKeysWithDictionary:dict];
       _idNum = (NSInteger)[dict objectForKey:@"id"];
        _actionName = [dict objectForKey:@"name"];
     
    }
    return self;
}
/*
 从文件中解析对象
 */
-(id) initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]){
        self.actionName = [decoder decodeObjectForKey:@"name"];
        self.idNum  = [decoder decodeInt32ForKey:@"id"];
    }
    return  self;
}
/*
 将对象写入 文件
 */

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.actionName forKey:@"name"];
    [encoder encodeInt32:self.idNum forKey:@"id"];
    
}
@end
