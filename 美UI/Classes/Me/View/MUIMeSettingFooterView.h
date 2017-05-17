//
//  MUIMeSettingFooterView.h
//  美UI
//
//  Created by Lee on 16-2-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MUIMeSettingFooterView;

@protocol MUIMeSettingFooterViewDelegate <NSObject>

@optional
- (void)settingFooterView:(MUIMeSettingFooterView *)footer logout:(UIButton *)logout;
- (void)settingFooterView:(MUIMeSettingFooterView *)footer clearCache:(UIButton *)clear;

@end


@interface MUIMeSettingFooterView : UIView

/**
 *  代理属性
 */
@property (nonatomic ,weak) id <MUIMeSettingFooterViewDelegate> delegate;
@property (nonatomic, assign) CGFloat cacheSize;

+ (instancetype)settingFooter;

@end
