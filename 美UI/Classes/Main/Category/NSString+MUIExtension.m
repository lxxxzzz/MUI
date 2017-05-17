//
//  NSString+MUIExtension.m
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "NSString+MUIExtension.h"

@implementation NSString (MUIExtension)

- (CGSize)sizeWithText:(CGSize)constrained font:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [self boundingRectWithSize:constrained
                                     options:
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil].size;
    
    return size;
}

- (NSString *)valiMobile {
    if (self.length < 11) {
        return @"手机号码必须是11位";
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        } else {
            return @"手机号码格式不正确";
        }
    }
    return nil;
}

@end
