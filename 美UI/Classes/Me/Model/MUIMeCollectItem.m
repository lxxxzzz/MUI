//
//  MUIMeCollectItem.m
//  美UI
//
//  Created by Lee on 16-1-6.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIMeCollectItem.h"
#import "Item.h"
#import <MJExtension.h>

@implementation MUIMeCollectItem

+ (instancetype)itemWithDict:(NSDictionary *)dict withTag:(NSArray *)tags {
    MUIMeCollectItem *item = [[MUIMeCollectItem alloc] init];
    item.category = dict[@"tag_name"];
    NSArray *arr = dict[@"items"];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *home in arr) {
        Item *item = [Item mj_objectWithKeyValues:home];
        item.user_tag_history = tags;
        [arrM addObject:item];
    }
    
    item.items = arrM;
    return item;
}

@end
