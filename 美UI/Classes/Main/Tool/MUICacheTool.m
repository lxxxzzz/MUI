//
//  MUICacheTool.m
//  美UI
//
//  Created by Lee on 16-3-28.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUICacheTool.h"
#import "FMDatabase.h"
#import "Item.h"

@implementation MUICacheTool

static FMDatabase *_db;

+ (void)initialize {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    if ([_db open]) {
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_item (id integer PRIMARY KEY ,item blob NOT NULL, pic_id text NOT NULL);"];
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_tags (id integer PRIMARY KEY ,tag text NOT NULL);"];
    }
}

+ (NSArray *)items {
    FMResultSet *result = [_db executeQuery:@"SELECT * FROM t_item;"];
    NSMutableArray *arrM = [NSMutableArray array];
    while (result.next) {
        NSData *data = [result dataForColumn:@"item"];
        Item *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [arrM addObject:item];
    }
    return arrM;
}

+ (void)addItems:(NSArray *)items {
    for (Item *item in items) {
        if ([self isExistWithPicture:item.pic_id]) {
            // 如果有重复的则不添加到数据库中去
            return;
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [_db executeUpdate:@"INSERT INTO t_item(item ,pic_id ) VALUES(?, ?)", data, item.pic_id];
    }
}

+ (void)deleteAllData {
    [_db executeUpdate:@"DELETE FROM t_item;"];
}

+ (NSInteger)count {
    FMResultSet *result = [_db executeQuery:@"SELECT * FROM t_item;"];
    NSInteger i = 0;
    while (result.next) {
        i ++;
    }
    return i;
}

//通过图片id判断数据是否存在
+ (BOOL)isExistWithPicture:(NSString *)picture {
    BOOL isExist = NO;
    FMResultSet *resultSet= [_db executeQuery:@"SELECT * FROM t_item where pic_id = ?",picture];
    while ([resultSet next]) {
        isExist = YES;
    }
    return isExist;
}

+ (NSMutableArray *)tags
{
    FMResultSet *result = [_db executeQuery:@"SELECT tag FROM t_tags;"];
    NSMutableArray *arrM = [NSMutableArray array];
    while (result.next)
    {
        NSData *data = [result dataForColumn:@"tag"];
        NSString *tagName = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [arrM addObject:tagName];
    }
    return arrM;
}

+ (void)addTags:(NSArray *)tags
{
    for (NSString *tag in tags)
    {
        if ([self isExistWithTags:tag])
        {
            // 如果有重复的则不添加到数据库中去
            return;
        }
        [_db executeUpdate:@"INSERT INTO t_tags(tag) VALUES(?)", tag];
    }
}

+ (void)setupTags:(NSArray *)tags
{
    [_db executeUpdate:@"DELETE FROM t_tags;"];
    for (NSString *tag in tags)
    {
        [_db executeUpdate:@"INSERT INTO t_tags(tag) VALUES(?)", tag];
    }
}

+ (BOOL)isExistWithTags:(NSString *)tag
{
    BOOL isExist = NO;
    FMResultSet *resultSet= [_db executeQuery:@"SELECT * FROM t_tags where tag = ?",tag];
    while ([resultSet next])
    {
        isExist = YES;
    }
    return isExist;
}

@end
