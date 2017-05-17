//
//  MUIMeHeaderView.m
//  美UI
//
//  Created by Lee on 16-1-4.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIMeHeaderView.h"
#import "UIImage+Stretch.h"
#import "MUISegmentControl.h"
#import "WaveView.h"

@interface MUIMeHeaderView () <WaveViewDeleagate>

@property (nonatomic, strong) WaveView *waveView;
@end

@implementation MUIMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.userName];
        [self addSubview:self.iconImage];
        [self addSubview:self.waveView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.waveView.frame = CGRectMake(0, self.frame.size.height - 6, self.frame.size.width, 6);
}

- (void)drawRect:(CGRect)rect {
    // 1.获得上下文
    [[UIImage imageNamed:@"personal_background"] drawInRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画第一个圆
    CGFloat smallW = 80;
    CGFloat smallH = smallW;
    CGRect icon = self.iconImage.frame;
    CGFloat smallY = self.iconImage.frame.origin.y - (smallH - self.iconImage.frame.size.height) / 2.0;
    CGFloat smallX = SCREEN_WIDTH * 0.5 - smallW * 0.5;
    [RGB(79, 79, 79) set];
    CGContextAddEllipseInRect(ctx, CGRectMake(smallX, smallY, smallW, smallH));
    // 从上下文中,取出UIImage
    CGContextSetLineWidth(ctx, 8); //设置线宽画圆环
    CGContextStrokePath(ctx);
    
    // 画第二个圆
    CGFloat bigW = 96;
    CGFloat bigY = self.iconImage.frame.origin.y - (bigW - self.iconImage.frame.size.height) / 2.0;
    CGFloat bigX = SCREEN_WIDTH * 0.5 - bigW * 0.5;
    [RGB(61, 61, 61) set];
    CGContextAddEllipseInRect(ctx, CGRectMake(bigX, bigY, bigW, bigW));
    
    // 从上下文中,取出UIImage
    CGContextSetLineWidth(ctx, 8); //设置线宽画圆环
    
    // 2.显示所绘制的东西
    CGContextStrokePath(ctx);
    // 3.结束上下文
    UIGraphicsEndImageContext();
}

- (void)login {
    if ([self.delegate respondsToSelector:@selector(login)]) {
        [self.delegate login];
    }
}

- (void)waveView:(WaveView *)waveView didMoveToPoint:(CGPoint)point {
    self.iconImage.bounds = CGRectMake(0, 0, 72, 72);
    CGPoint p = [waveView convertPoint:point toView:self];
    CGFloat y = p.y - self.iconImage.frame.size.height;
    CGRect rect = self.iconImage.frame;
    rect.origin.y = y;
    rect.origin.x = self.center.x - self.iconImage.frame.size.height / 2;
    self.iconImage.frame = rect;
    [self setNeedsDisplay];
}

- (UILabel *)userName {
    if (_userName == nil) {
        _userName = [[UILabel alloc] init];
        _userName.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 100, 176 - 15, 200, 15);
        _userName.textColor = [UIColor whiteColor];
        _userName.font = [UIFont systemFontOfSize:15];
        _userName.textAlignment = NSTextAlignmentCenter;
    }
    return _userName;
}

- (UIImageView *)iconImage {
    if (_iconImage == nil) {
        CGFloat iconW = 72;
        CGFloat iconH = iconW;
        CGFloat iconX = SCREEN_WIDTH * 0.5 - iconW * 0.5;
        CGFloat iconY = 60;
        _iconImage = [[UIImageView alloc] init];
        _iconImage.frame = CGRectMake(iconX, iconY, iconW, iconH);
        _iconImage.layer.cornerRadius = iconW * 0.5;
        _iconImage.layer.masksToBounds = YES;
        _iconImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
        [_iconImage addGestureRecognizer:tap];
    }
    return _iconImage;
}

- (WaveView *)waveView{
    if (_waveView == nil) {
        _waveView = [[WaveView alloc] init];
        _waveView.delegate = self;
    }
    return _waveView;
}

@end

