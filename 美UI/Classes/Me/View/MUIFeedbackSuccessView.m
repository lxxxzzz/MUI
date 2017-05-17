//
//  MUIFeedbackSuccessView.m
//  美UI
//
//  Created by Lee on 16-3-17.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIFeedbackSuccessView.h"

@implementation MUIFeedbackSuccessView

+ (instancetype)successView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

@end
