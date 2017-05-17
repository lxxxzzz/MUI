//
//  WaveView.m
//  美UI
//
//  Created by Lee on 17/3/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()

@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *maskShapeLayer;
@property (nonatomic, assign) CGFloat angularSpeed;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, strong) UIColor *color;

@end

@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.angularSpeed = 1.8;
        self.speed = 6;
        self.color = [UIColor whiteColor];
        [self startAnimation];
    }
    return self;
}

- (void)startAnimation {
    if (self.shapeLayer != nil) {
        return;
    }
    
    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.fillColor = self.color.CGColor;
    [self.layer addSublayer:self.shapeLayer];
    
    self.maskShapeLayer = [[CAShapeLayer alloc] init];
    self.maskShapeLayer.fillColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
    [self.layer addSublayer:self.maskShapeLayer];
    
//    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePath)] ;
//    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        [self.displayLink invalidate];
        self.displayLink = nil;
        [self.shapeLayer removeFromSuperlayer];
        [self.maskShapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        self.maskShapeLayer = nil;
    }];
}

- (void)updatePath {
    
    self.offsetX -= self.speed;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, 0, height);
    
    CGFloat maskY = 0;
    
    CGFloat y = 0;
    for (CGFloat x=0; x<width; x++) {
        y = height * sin(0.01 * (self.angularSpeed * x + self.offsetX));
        CGPathAddLineToPoint(path, NULL, x, y);
        
        maskY = -y;
        CGPathAddLineToPoint(path2, NULL, x, maskY);
    }
    
    CGFloat centerX = width / 2.0;
    CGFloat waveHeight = height * sin(0.01 * (self.angularSpeed * centerX + self.offsetX));
    !self.block ? : self.block(CGPointMake(centerX, waveHeight));
    if ([self.delegate respondsToSelector:@selector(waveView:didMoveToPoint:)]) {
        [self.delegate waveView:self didMoveToPoint:CGPointMake(centerX, waveHeight)];
    }
    
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.shapeLayer.path = path;
    
    CGPathAddLineToPoint(path2, NULL, width, height);
    CGPathAddLineToPoint(path2, NULL, 0, height);
    CGPathCloseSubpath(path2);
    self.maskShapeLayer.path = path2;
}

@end
