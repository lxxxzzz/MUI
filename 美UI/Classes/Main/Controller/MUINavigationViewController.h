//
//  MUINavigationViewController.h
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUINavigationViewController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController hidesBottomBar:(BOOL)hide animated:(BOOL)animated;

@end
