//
//  MUISphereView.m
//  美UI
//
//  Created by Lee on 16-1-7.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUISphereView.h"
#import "MUIMatrix.h"

@interface MUISphereView ()<UIGestureRecognizerDelegate>

@end

@implementation MUISphereView
{
    NSMutableArray *tags;
    NSMutableArray *coordinate;
    MUIPoint normalDirection;
    CGPoint last;
    
    CGFloat velocity;
    
    CADisplayLink *timer;
    CADisplayLink *inertia;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:gesture];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < datas.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:datas[i] forState:UIControlStateNormal];
        [self setApperanceForButton:btn];

        [array addObject:btn];
        [self addSubview:btn];
    }
    [self setCloudTags:array];
}

- (void)setApperanceForButton:(UIButton *)btn
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:24.0];
    btn.frame = CGRectMake(0, 0, 150, 20);
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonPressed:(UIButton *)btn
{
    [self timerStop];

    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(sphereView:selectedButton:)])
            {
                [self.delegate sphereView:self selectedButton:btn];
            }
            
            [self timerStart];
        }];
    }];
}

#pragma mark - initial set

- (void)setCloudTags:(NSArray *)array
{
    tags = [NSMutableArray arrayWithArray:array];
    coordinate = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger i = 0; i < tags.count; i ++) {
        UIView *view = [tags objectAtIndex:i];
        view.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    }
    
    CGFloat p1 = M_PI * (3 - sqrt(5));
    CGFloat p2 = 2. / tags.count;
    
    for (NSInteger i = 0; i < tags.count; i ++) {
        
        CGFloat y = i * p2 - 1 + (p2 / 2);
        CGFloat r = sqrt(1 - y * y);
        CGFloat p3 = i * p1;
        CGFloat x = cos(p3) * r;
        CGFloat z = sin(p3) * r;
        
        
        MUIPoint point = MUIPointMake(x, y, z);
        NSValue *value = [NSValue value:&point withObjCType:@encode(MUIPoint)];
        [coordinate addObject:value];
        
        CGFloat time = (arc4random() % 10 + 10.) / 20.;
        [UIView animateWithDuration:time delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setTagOfPoint:point andIndex:i];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    NSInteger a =  arc4random() % 10 - 5;
    NSInteger b =  arc4random() % 10 - 5;
    normalDirection = MUIPointMake(a, b, 0);
    [self timerStart];
}

#pragma mark - set frame of point

- (void)updateFrameOfPoint:(NSInteger)index direction:(MUIPoint)direction andAngle:(CGFloat)angle
{
    
    NSValue *value = [coordinate objectAtIndex:index];
    MUIPoint point;
    [value getValue:&point];
    
    MUIPoint rPoint = MUIPointMakeRotation(point, direction, angle);
    value = [NSValue value:&rPoint withObjCType:@encode(MUIPoint)];
    coordinate[index] = value;
    
    [self setTagOfPoint:rPoint andIndex:index];
    
}

- (void)setTagOfPoint: (MUIPoint)point andIndex:(NSInteger)index
{
    UIView *view = [tags objectAtIndex:index];
    view.center = CGPointMake((point.x + 1) * (self.frame.size.width / 2.), (point.y + 1) * self.frame.size.width / 2.);
    
    CGFloat transform = (point.z + 2) / 3;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, transform, transform);
    view.layer.zPosition = transform;
    view.alpha = transform;
    if (point.z < 0) {
        view.userInteractionEnabled = NO;
    }else {
        view.userInteractionEnabled = YES;
    }
}

#pragma mark - autoTurnRotation

- (void)timerStart
{
    timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoTurnRotation)];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)timerStop
{
    [timer invalidate];
    timer = nil;
}

- (void)autoTurnRotation
{
    for (NSInteger i = 0; i < tags.count; i ++) {
        [self updateFrameOfPoint:i direction:normalDirection andAngle:0.002];
    }
    
}

#pragma mark - inertia

- (void)inertiaStart
{
    [self timerStop];
    inertia = [CADisplayLink displayLinkWithTarget:self selector:@selector(inertiaStep)];
    [inertia addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)inertiaStop
{
    [inertia invalidate];
    inertia = nil;
    [self timerStart];
}

- (void)inertiaStep
{
    if (velocity <= 0) {
        [self inertiaStop];
    }else {
        velocity -= 70.;
        CGFloat angle = velocity / self.frame.size.width * 2. * inertia.duration;
        for (NSInteger i = 0; i < tags.count; i ++) {
            [self updateFrameOfPoint:i direction:normalDirection andAngle:angle];
        }
    }
    
}

#pragma mark - gesture selector

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        last = [gesture locationInView:self];
        [self timerStop];
        [self inertiaStop];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [gesture locationInView:self];
        MUIPoint direction = MUIPointMake(last.y - current.y, current.x - last.x, 0);
        
        CGFloat distance = sqrt(direction.x * direction.x + direction.y * direction.y);
        
        CGFloat angle = distance / (self.frame.size.width / 2.);
        
        for (NSInteger i = 0; i < tags.count; i ++) {
            [self updateFrameOfPoint:i direction:direction andAngle:angle];
        }
        normalDirection = direction;
        last = current;
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocityP = [gesture velocityInView:self];
        velocity = sqrt(velocityP.x * velocityP.x + velocityP.y * velocityP.y);
        [self inertiaStart];
        
    }
}

@end
