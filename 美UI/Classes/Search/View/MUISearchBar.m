//
//  MUISearchBar.m
//  美UI
//
//  Created by Lee on 16-1-8.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUISearchBar.h"

@interface MUISearchBar ()


@end

@implementation MUISearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self sizeToFit];
        [self setPlaceholder:@"搜索APP名称或标签"];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self setSearchTextFieldBackgroundColor:BG_COLOR];
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:RGB(171, 171, 171)];
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
    }
    return self;
}


- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    self.barTintColor = [UIColor whiteColor];
    searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = backgroundColor;
}


@end
