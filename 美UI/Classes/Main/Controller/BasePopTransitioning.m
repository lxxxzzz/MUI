//
//  BasePopTransitioning.m
//  美UI
//
//  Created by Lee on 16/8/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "BasePopTransitioning.h"
#import "MUIBaseViewController.h"
#import "DetailViewController.h"
#import "DetailCell.h"
#import "BaseCell.h"
#import "Const.h"

@implementation BasePopTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    DetailViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.collectView.hidden = YES;
    
    MUIBaseViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.currentIndexPath = [NSIndexPath indexPathForItem:toVC.currentIndexPath.item + fromVC.selectedIndex inSection:0];
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    
    UIView *containerView = [transitionContext containerView];
    
    DetailCell *dcell = (DetailCell *)[fromVC.collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:fromVC.selectedIndex inSection:0]];
    UIView *snapShotView = [dcell.imageView snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = [containerView convertRect:dcell.imageView.frame fromView:dcell.imageView.superview];
    
    BaseCell *cell = (BaseCell *)[toVC.collectView cellForItemAtIndexPath:toVC.currentIndexPath];
    cell.imageView.hidden = YES;

    toVC.finalCellRect = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];

    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.alpha = 1.0;
        snapShotView.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    } completion:^(BOOL finished) {
        [snapShotView removeFromSuperview];
        fromVC.collectView.hidden = NO;
        cell.imageView.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
