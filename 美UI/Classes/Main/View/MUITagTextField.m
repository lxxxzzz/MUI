//
//  MUITagTextField.m
//  美UI
//
//  Created by Lee on 16-4-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUITagTextField.h"

@interface MUITagTextField ()
/**
 *  layer
 */
@property (nonatomic, strong) CAShapeLayer *borderLayer;
@end

@implementation MUITagTextField

+ (instancetype)textWithTarget:(id)target action:(SEL)action
{
    MUITagTextField *text = [[MUITagTextField alloc] init];
    [text addTarget:target action:action forControlEvents:UIControlEventEditingChanged];
    return text;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 14;
        self.returnKeyType = UIReturnKeyNext;
        self.font = [UIFont systemFontOfSize:12];
        self.placeholder = @"添加标签";
        self.height = MUITagHeight;
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        //设置显示模式为永远显示(默认不显示)
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (void)deleteBackward
{
    if (_deleteBlock)
    {
        _deleteBlock();
    }
    
    [super deleteBackward];
}

- (CAShapeLayer *)borderLayer
{
    if (!_borderLayer)
    {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.lineWidth = 1.0f;
        //虚线边框
        _borderLayer.lineDashPattern = @[@5, @5];
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        _borderLayer.strokeColor = [[UIColor grayColor] CGColor];
    }
    return _borderLayer;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    self.borderLayer.bounds = CGRectMake(0, 0, self.width, self.height);
    self.borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.borderLayer.bounds cornerRadius:CGRectGetWidth(self.borderLayer.bounds)/2].CGPath;
}

- (void)setShowBorder:(BOOL)showBorder
{
    _showBorder = showBorder;
    
    if (showBorder)
    {
        [self.layer addSublayer:self.borderLayer];
    }
    else
    {
        [self.borderLayer removeFromSuperlayer];
    }
}

- (void)shake
{
    CAKeyframeAnimation *animationKey = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animationKey setDuration:0.5f];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [animationKey setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [animationKey setKeyTimes:times];

    [self.layer addAnimation:animationKey forKey:@"TextFieldShake"];
}


@end
