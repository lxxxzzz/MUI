//
//  DismissTranslation.m
//  美UI
//
//  Created by Lee on 16/8/29.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "DismissTranslation.h"
#import "LoginViewController.h"
#import "MUIMeViewController.h"
#import "Const.h"

@implementation DismissTranslation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UINavigationController *nav = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    LoginViewController *fromVc = (LoginViewController *)[nav.topViewController.childViewControllers firstObject];
    
    UIButton *btnView = fromVc.login;
    CGFloat radius = MIN(btnView.frame.size.width, btnView.frame.size.height);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIView *containerView = [transitionContext containerView];
    UIView *animationView = [[UIView alloc] init];
    CGPoint point = [self relativeFrameForScreenWithView:btnView];
    animationView.frame = CGRectMake(point.x, point.y, radius, radius);
    animationView.backgroundColor = RGB(255, 220, 68);
    animationView.layer.cornerRadius = radius/2;
    animationView.layer.masksToBounds = YES;
    animationView.layer.transform = CATransform3DIdentity;
    [containerView addSubview:animationView];
    
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    toVC.view.alpha = 0;
    btnView.hidden = YES;
    [containerView addSubview:toVC.view];
    
    CGFloat size = MAX(toVC.view.frame.size.width, toVC.view.frame.size.height) * 1.6;
    CATransform3D fina3D = CATransform3DMakeScale(size/radius, size/radius, 1);
    [UIView animateWithDuration:0.5 animations:^{
        animationView.layer.transform = fina3D;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [animationView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (CGPoint)relativeFrameForScreenWithView:(UIView *)v {
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != screenWidth || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGPointMake(x, y);
}

@end
