//
//  BasePushTransitioning.m
//  美UI
//
//  Created by Lee on 16/8/2.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "BasePushTransitioning.h"
#import "MUIBaseViewController.h"
#import "DetailViewController.h"
#import "BaseCell.h"
#import "Const.h"

@implementation BasePushTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    MUIBaseViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    DetailViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    toVc.collectView.hidden = YES;
    
    UIView *containerView = [transitionContext containerView];
    
    fromVc.currentIndexPath = [[fromVc.collectView indexPathsForSelectedItems] firstObject];

    BaseCell *cell = (BaseCell *)[fromVc.collectView cellForItemAtIndexPath:fromVc.currentIndexPath];
    
    UIView *snapShotView = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    snapShotView.layer.cornerRadius = 5;
    snapShotView.layer.masksToBounds = YES;
    snapShotView.frame = fromVc.finalCellRect = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];

    [containerView addSubview:toVc.view];
    [containerView addSubview:snapShotView];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        toVc.view.backgroundColor = [UIColor whiteColor];
        CGFloat width = SCREEN_WIDTH - 24;
        CGFloat height = width * cell.imageView.frame.size.height / cell.imageView.frame.size.width;
        snapShotView.frame = CGRectMake(12, 12 , width, height);
    } completion:^(BOOL finished) {
        [snapShotView removeFromSuperview];
        toVc.collectView.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
}

@end
