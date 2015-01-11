//
//  DBManager.m
//  QR code
//
//  Created by JunLee on 15/1/10.
//  Copyright (c) 2015年 斌. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@implementation DBManager
- (NSString *)databasePathWithDatabaseName:(NSString *)databaseName
{
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:databaseName];
    NSLog(@"数据库地址：%@", dbPath);
    return dbPath;
    
}
+ (NSString *)datamanagerDatabasePathWithDatabaseName:(NSString *)databaseName
{
    DBManager *dataManager = [[DBManager alloc] init];
    [dataManager autorelease];
    return [dataManager databasePathWithDatabaseName:databaseName];
    
}

-(BOOL)connectionDatabaseName:(NSString *)databaseName
                    tableName:(NSString *)tableName
                    sqlString:(NSString *)sql
{
    NSString *dbPath = [DBManager datamanagerDatabasePathWithDatabaseName:databaseName];
    NSLog(@"数据库路径 ： %@", dbPath );
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed!");
        return NO;
    }
    return [database executeUpdate:sql];
}
+ (BOOL)ManagerDatabaseName:(NSString *)databaseName tableName:(NSString *)tableName sqlString:(NSString *)sql
{
    DBManager *databaseManager = [[[DBManager alloc] init] autorelease];
    BOOL result = [databaseManager connectionDatabaseName:databaseName
                                                tableName:tableName
                                                sqlString:sql];
    return result;
}
- (BOOL)connectionDatabaseName:(NSString *)databaseName tableName:(NSString *)tableName column1Name:(NSString *)column1 column1Type:(NSString *)type1 column2Name:(NSString *)column2 column2Type:(NSString *)type2 column3Name:(NSString *)column3 column3Type:(NSString *)type3 column4Name:(NSString *)column4 column4Type:(NSString *)type4
{
    NSString *dbPath = [DBManager datamanagerDatabasePathWithDatabaseName:databaseName];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"数据库打开失败");
        
    }
    
    NSString *sqlStr = nil;
    if (column4 == nil && column3 != nil) {
        NSLog(@"column4 wei kong");
        sqlStr = [NSString stringWithFormat:@"create table %@ (%@ %@, %@ %@, %@ %@)", tableName, column1, type1, column2, type2, column3, type3];
    } else if (column3 == nil && column2 != nil) {
        sqlStr = [NSString stringWithFormat:@"create table %@ (%@ %@, %@ %@)", tableName, column1, type1, column2, type2];
    } else if (column2 == nil && column1 != nil) {
        sqlStr = [NSString stringWithFormat:@"create table %@ (%@ %@)", tableName, column1, type1];
    }
    else {
        sqlStr = [NSString stringWithFormat:@"create table %@ (%@ %@, %@ %@, %@ %@, %@ %@)", tableName, column1, type1, column2, type2, column3, type3, column4, type4];
    }
    NSLog(@"sql 语句: %@", sqlStr);
    
    BOOL create =  [database executeUpdate:sqlStr];
    [database close];
    return create;
}
+(BOOL)ManagerWithConnectionDatabaseName:(NSString *)databaseName tableName:(NSString *)tableName
                             column1Name:(NSString *)column1 column1Type:(NSString *)type1 column2Name:(NSString *)column2 column2Type:(NSString *)type2 column3Name:(NSString *)column3 column3Type:(NSString *)type3 column4Name:(NSString *)column4 column4Type:(NSString *)type4
{
    DBManager *databaseManager = [[DBManager alloc] init];
    return [databaseManager connectionDatabaseName:databaseName tableName:tableName column1Name:column1 column1Type:type1 column2Name:column2 column2Type:type2 column3Name:column3 column3Type:type3 column4Name:column4 column4Type:type4];
  //  [databaseManager autorelease];
}

-(BOOL)useDatabase:(NSString *)databaseName insertIntoTableName:(NSString *)tableName value1:(NSString *)value1 value2:(NSString *)value2 value3:(NSString *)value3 value4:(NSString *)value4
{
    NSString *dbPath = [DBManager datamanagerDatabasePathWithDatabaseName:databaseName];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    NSString *insertStr = nil;
    if (value2 == nil) {
        insertStr = [NSString stringWithFormat:@"insert into %@ values ('%@')", tableName, value1];
    } else if (value3 == nil && value2 != nil) {
        insertStr = [NSString stringWithFormat:@"insert into %@ values ('%@', '%@')", tableName, value1, value2];
    } else if (value4 == nil && value3 != nil) {
        insertStr = [NSString stringWithFormat:@"insert into %@ values ('%@', '%@', '%@')", tableName, value1, value2, value3];
    } else {
        insertStr = [NSString stringWithFormat:@"insert into %@ values ('%@', '%@', '%@', '%@')", tableName, value1, value2, value3, value4];
    }
    
    NSLog(@"insert 语句 ：%@", insertStr);
   BOOL insert = [database executeUpdate:insertStr];
//    if (insert) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
    [database close];
    return insert;
}
- (BOOL)useDatabase:(NSString *)databaseName
    deleteFromTable:(NSString *)tableName

       whereColumn1:(NSString *)column1
             value1:(NSString *)value1
         andColumn2:(NSString *)column2
             value2:(NSString *)value2
{
    NSString *dbPath = [DBManager datamanagerDatabasePathWithDatabaseName:databaseName];
    NSLog(@"数据库地址 %@", dbPath);
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    NSString *deleteStr = nil;
    if (column2 == nil) {
        deleteStr = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, column1, value1];
    } else {
        deleteStr = [NSString stringWithFormat:@"delete from %@ where %@ = '%@' and %@ = '%@'", tableName, column1, value1, column2, value2];
    }
    NSLog(@"sql语句：%@", deleteStr);
    BOOL delete = [database executeUpdate:deleteStr];
    if (delete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [database close];
    return delete;
}
- (NSMutableArray *)useDatabase:(NSString *)databaseName
             selectAllFromTable:(NSString *)tableName
                   whereColumn1:(NSString *)column1 value1:(NSString *)value1
                        column2:(NSString *)column2 value2:(NSString *)value2
{
    NSString *dbPath = [DBManager datamanagerDatabasePathWithDatabaseName:databaseName];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"打开数据库出错");
        return NO;
    }
    NSString *sqlStr = nil;
    if (column2 == nil) {
        sqlStr = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, column1, value1];
    } else {
        sqlStr = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%@'", tableName, column1, value1, column2, value2];
    }
    NSLog(@"sql 语句%@", sqlStr);
    FMResultSet *resultSet = [database executeQuery:sqlStr];

    NSMutableArray *array = [NSMutableArray array];
    while ([resultSet next]) {
        [array addObject: [resultSet resultDictionary]];
    }
    
    
    [database close];
    return array;
}

@end
