//
//  MUILoginViewController.m
//  美UI
//
//  Created by Lee on 16-3-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUILoginViewController.h"
#import "MUILoginDetailViewController.h"
#import "MUIRegisterViewController.h"
#import "UIImage+Stretch.h"
#import "UIBarButtonItem+MUIExtension.h"
#import "LoginViewController.h"
#import "DismissTranslation.h"

@interface MUILoginViewController () <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) DismissTranslation *dismissAnimation;

@end

@implementation MUILoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.segment addTarget:self action:@selector(selectItemAtIndex:) forControlEvents:UIControlEventValueChanged];

    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, self.scrollView.frame.size.height);
    self.scrollView.scrollEnabled = NO;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];

    LoginViewController *loginVc = [[LoginViewController alloc] init];
    loginVc.transitioningDelegate = self;
    loginVc.dismissCompletion = self.dismiss;
    MUIRegisterViewController *registerVc = [[MUIRegisterViewController alloc] init];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self action:@selector(cancel)];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self addChildViewController:loginVc];
    [self addChildViewController:registerVc];
}

- (void)viewDidLayoutSubviews {
    [self selectItemAtIndex:self.segment];
}

- (void)selectItemAtIndex:(UISegmentedControl *)seg {
    CGFloat x = seg.selectedSegmentIndex * SCREEN_WIDTH;
    UIViewController *vc = self.childViewControllers[self.segment.selectedSegmentIndex];
    vc.view.x = x;
    vc.view.y = 0;
    vc.view.width = SCREEN_WIDTH;
    vc.view.height = self.scrollView.height;
    self.navigationItem.title = [seg titleForSegmentAtIndex:seg.selectedSegmentIndex];
    [self.scrollView addSubview:vc.view];
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)cancel {
    [self.view endEditing:YES];
    !self.cancelBlock ? : self.cancelBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimation;
}

- (DismissTranslation *)dismissAnimation {
    if (_dismissAnimation == nil) {
        _dismissAnimation = [[DismissTranslation alloc] init];
    }
    return _dismissAnimation;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [UIApplication sharedApplication].statusBarHidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [UIApplication sharedApplication].statusBarHidden = NO;
//}


@end
