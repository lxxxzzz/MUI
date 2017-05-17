//
//  MUICacheTool.h
//  美UI
//
//  Created by Lee on 16-3-28.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUICacheTool : NSObject

+ (NSInteger)count;
+ (NSArray *)items;
+ (void)addItems:(NSArray *)items;

+ (NSMutableArray *)tags;
+ (void)addTags:(NSArray *)tags;
+ (void)setupTags:(NSArray *)tags;
+ (void)deleteAllData;

@end
