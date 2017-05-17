//
//  MUISettingItem.m
//  美UI
//
//  Created by Lee on 16-2-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUISettingItem.h"

@implementation MUISettingItem

+ (instancetype)itemWithTitle:(NSString *)title destVc:(Class)destVc
{
    MUISettingItem *item = [[self alloc] init];
    item.title = title;
    item.destVc = destVc;
    return item;
}

@end
