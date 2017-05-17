//
//  NSString+MUIExtension.h
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MUIExtension)

/**
 *  计算文字的size
 *
 */
- (CGSize)sizeWithText:(CGSize)constrained font:(UIFont *)font;
- (NSString *)valiMobile;

@end
