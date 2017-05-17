//
//  MUINoResultView.m
//  美UI
//
//  Created by Lee on 16-3-22.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUINoResultView.h"

@implementation MUINoResultView

+ (instancetype)noView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MUINoResultView" owner:nil options:nil] lastObject];
}

@end
