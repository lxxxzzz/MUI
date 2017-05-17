//
//  TagButton.h
//  美UI
//
//  Created by Lee on 16/9/2.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagButton : UIButton

/**
 *  文字的颜色
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 *  选中时文字的颜色
 */
@property (nonatomic, strong) UIColor *selectedTextColor;
/**
 *  背景的颜色
 */
@property (nonatomic, strong) UIColor *bgColor;
/**
 *  选中时背景的颜色
 */
@property (nonatomic, strong) UIColor *selectedBgColor;
/**
 *  边框的颜色
 */
@property (nonatomic, strong) UIColor *borderColor;


+ (instancetype)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
