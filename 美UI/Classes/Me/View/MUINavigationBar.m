//
//  MUINavigationBar.m
//  美UI
//
//  Created by Lee on 16-4-8.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUINavigationBar.h"

@interface MUINavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MUINavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.titleLabel];
        self.backgroundColor = RGBA(50, 50, 50, 1.0f);
        self.alpha = 0.0f;
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = NAV_BAR_FONT;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = [title isEqualToString:MUIDefaultTitle] ? @"" : title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 32, SCREEN_WIDTH, 16);
}

//- (void)setFrame:(CGRect)frame
//{
//    frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
//    [super setFrame:frame];
//}

@end
