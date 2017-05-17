//
//  MUISphereView.h
//  美UI
//
//  Created by Lee on 16-1-7.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MUISphereView;
@protocol MUISphereViewDelegate <NSObject>

@optional
- (void)sphereView:(MUISphereView *)sphereView selectedButton:(UIButton *)btn;

@end

@interface MUISphereView : UIView

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, weak) id <MUISphereViewDelegate> delegate;

/**
 *  Starts the cloud autorotation animation.
 */
- (void)timerStart;

/**
 *  Stops the cloud autorotation animation.
 */
- (void)timerStop;

@end
