//
//  DBManager.h
//  QR code
//
//  Created by JunLee on 15/1/10.
//  Copyright (c) 2015年 斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject


/**
 *  数据库所在位置
 *  @param databaseName 数据库名
 *  @return 数据库地址
 */
- (NSString *)databasePathWithDatabaseName:(NSString *)databaseName;
+ (NSString *)datamanagerDatabasePathWithDatabaseName:(NSString *)databaseName;


/**
 *  连接数据库，并且创建表
 *  @param databaseName 要创建的数据库名称  例如 test.db
 *  @param tableName 创建的表名 如 table1（可为空）
 *  @param sql 创建表需要的语句
 *  @return 返回是否创建成功
 */
- (BOOL)connectionDatabaseName:(NSString *)databaseName
                     tableName:(NSString *)tableName
                     sqlString:(NSString *)sql;

+ (BOOL)ManagerDatabaseName:(NSString *)databaseName
                  tableName:(NSString *)tableName
                  sqlString:(NSString *) sql;


/**
 *  利用参数列名和列类型创建数据库和表
 *  @param databaseName 同上
 *  @param tableName 同上
 *  @param column1 第一列列名
 *  @param type1 第一列类型
 *  @param column2 同上 可以为空
 *  @param type2 同上 可以为空
 *  @param column3 同上 可以为空
 *  @param type3 同上 可以为空
 *  @param column4 同上 可以为空
 *  @param type4 同上 可以为空
 *  @return 是否创建成功
 */
- (BOOL)connectionDatabaseName:(NSString *)databaseName
                     tableName:(NSString *)tableName
                   column1Name:(NSString *)column1 column1Type:(NSString *)type1
                   column2Name:(NSString *)column2 column2Type:(NSString *)type2
                   column3Name:(NSString *)column3 column3Type:(NSString *)type3
                   column4Name:(NSString *)column4 column4Type:(NSString *)type4;

+(BOOL)ManagerWithConnectionDatabaseName:(NSString *)databaseName tableName:(NSString *)tableName
                             column1Name:(NSString *)column1 column1Type:(NSString *)type1

                             column2Name:(NSString *)column2 column2Type:(NSString *)type2

                             column3Name:(NSString *)column3 column3Type:(NSString *)type3
                             column4Name:(NSString *)column4 column4Type:(NSString *)type4;
/**
 *  向表中插入数据
 *  @param databaseName 要插入的数据库
 *  @param tableName 要插入的表名
 *  @param value1 第一列的值
 *  @param value2 第二列的值
 *  @param value3 第三列的值
 *  @param value4 第四列的值
 *  @return 返回插入结果
 */
- (BOOL)useDatabase:(NSString *)databaseName insertIntoTableName:(NSString *)tableName
             value1:(NSString *)value1
             value2:(NSString *)value2
             value3:(NSString *)value3
             value4:(NSString *)value4;

/**
 *  根据条件删除表
 *  @param databaseName 数据库名
 *  @param tableName 表名
 *  @param column1 列名
 *  @param value1 值
 *  @param column2 列名2
 *  @param value2 值2
 *  @return 删除结果
 */
- (BOOL)useDatabase:(NSString *)databaseName
    deleteFromTable:(NSString *)tableName
       whereColumn1:(NSString *)column1 value1:(NSString *)value1
         andColumn2:(NSString *)column2 value2:(NSString *)value2;

// 查询
- (NSMutableArray *)useDatabase:(NSString *)databaseName
             selectAllFromTable:(NSString *)tableName
                   whereColumn1:(NSString *)column1 value1:(NSString *)value1
                        column2:(NSString *)column2 value2:(NSString *)value2;

@end
