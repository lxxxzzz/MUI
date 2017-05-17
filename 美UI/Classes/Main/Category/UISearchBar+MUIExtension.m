//
//  UISearchBar+MUIExtension.m
//  美UI
//
//  Created by Lee on 15-12-23.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "UISearchBar+MUIExtension.h"

@implementation UISearchBar (MUIExtension)

- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    self.barTintColor = [UIColor whiteColor];
    searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = backgroundColor;
}

@end
