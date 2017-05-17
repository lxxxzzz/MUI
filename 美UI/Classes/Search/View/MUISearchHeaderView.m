//
//  MUISearchHeaderView.m
//  美UI
//
//  Created by Lee on 16-1-8.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUISearchHeaderView.h"


@implementation MUISearchHeaderView

+ (instancetype)searchHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MUISearchHeaderView" owner:nil options:nil] lastObject];
}

@end
