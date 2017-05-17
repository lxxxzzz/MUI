//
//  MUIMeHeaderView.h
//  美UI
//
//  Created by Lee on 16-1-4.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MUISegmentControl;
@protocol MUIMeHeaderViewDelegate <NSObject>

@optional
- (void)segmentValueChange:(NSInteger)index;
- (void)login;
@end

@interface MUIMeHeaderView : UIView


@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, assign) id <MUIMeHeaderViewDelegate> delegate;

@end
