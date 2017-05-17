//
//  MUITagTextField.h
//  美UI
//
//  Created by Lee on 16-4-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUITagTextField : UITextField

/**
 *  删除时调用的block
 */
@property (nonatomic, copy) void (^deleteBlock)();
/**
 *  显示隐藏边框
 */
@property (nonatomic, assign) BOOL showBorder;

+ (instancetype)textWithTarget:(id)target action:(SEL)action;
- (void)shake;
@end
