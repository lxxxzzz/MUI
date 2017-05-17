//
//  LoginViewController.h
//  美UI
//
//  Created by Lee on 16/8/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) UIButton *login;
@property (nonatomic, copy) void(^dismissCompletion)();

@end
