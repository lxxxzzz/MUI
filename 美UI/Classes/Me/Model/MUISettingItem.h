//
//  MUISettingItem.h
//  美UI
//
//  Created by Lee on 16-2-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^optionBlock)();

@interface MUISettingItem : NSObject

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subTitle;
/**
 *  点击跳转的控制器
 */
@property (nonatomic, assign) Class destVc;
/**
 *  点击要做的事情
 */
@property (nonatomic, copy) optionBlock option;

+ (instancetype)itemWithTitle:(NSString *)title destVc:(Class)destVc;

@end
