//
//  MUISearchTableFooterView.m
//  美UI
//
//  Created by Lee on 15-12-25.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUISearchTableFooterView.h"

@implementation MUISearchTableFooterView

+ (instancetype)searchTableFooter
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MUISearchTableFooterView" owner:nil options:nil] lastObject];
}

- (IBAction)clear
{
    if ([self.delegate respondsToSelector:@selector(clearAll)])
    {
        [self.delegate clearAll];
    }
}

@end
