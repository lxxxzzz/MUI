//
//  MUIUserInfoItem.m
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIUserInfoItem.h"

@implementation MUIUserInfoItem

+ (instancetype)itemWithTitle:(NSString *)title name:(NSString *)name icon:(UIImage *)icon option:(MUIUserInfoItemOption)option
{
    MUIUserInfoItem *item = [[MUIUserInfoItem alloc] init];
    item.title = title;
    item.name = name;
    item.icon = icon;
    item.option = option;
    return item;
}


@end
