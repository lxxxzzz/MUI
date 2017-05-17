//
//  MUIResetPwdViewController.m
//  美UI
//
//  Created by Lee on 16-4-19.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIResetPwdViewController.h"
#import "MZTimerLabel.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+MUIExtension.h"
#import "MUIHttpParams.h"
#import "MUIHttpTool.h"
#import "User.h"
#import "UITextField+Shake.h"
#import "NSString+MUIExtension.h"

@interface MUIResetPwdViewController ()<MZTimerLabelDelegate, UITextFieldDelegate> {
    UILabel *timer_show; //倒计时label
}

@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *authCodeText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewCenterYConstraint;
@property (copy, nonatomic) NSString *authCode;

@end

@implementation MUIResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.accountText addTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [MUINotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [MUINotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self action:@selector(cancel)];
    
    self.navigationItem.title = @"重设密码";
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect kbRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 还有导航栏的高度
    CGFloat maxY = kbRect.size.height - (SCREEN_HEIGHT * 0.5 - 105 + 50) + 44;
    self.backViewCenterYConstraint.constant = MAX(maxY, 0) ;
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    self.backViewCenterYConstraint.constant = 0;
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)textFieldValueDidChange:(UITextField *)textField
{
    
}

- (void)timeCount {
    [self.authCodeBtn setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    timer_show = [[UILabel alloc] initWithFrame:self.authCodeBtn.bounds];//UILabel设置成和UIButton一样的尺寸和位置
    [self.authCodeBtn addSubview:timer_show];//把timer_show添加到authCodeBtn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:authCodeInterval];//倒计时时间20s
    timer_cutDown.timeFormat = @"ss秒";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor grayColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    self.authCodeBtn.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
    
    NSMutableDictionary *params = [MUIHttpParams registerMessageParams];
    params[@"mobile"] = self.accountText.text;
    
    [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
        
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            [SVProgressHUD showSuccessWithStatus:@"已成功"];
            self.authCode = code.data[@"code"];
        }
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
    }];
}

//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    [self.authCodeBtn setTitle:@"验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    self.authCodeBtn.userInteractionEnabled = YES;//按钮可以点击
}

- (IBAction)authCodeOnClick {
    NSString *str = [self.accountText.text valiMobile];
    if (str) {
        [SVProgressHUD showErrorWithStatus:str];
    } else {
        [self timeCount];
    }
}

- (IBAction)resetPasswordOnClick {
    if ([self checkRegisterInfo]) {
        // 发送注册请求
        NSMutableDictionary *params = [MUIHttpParams resetPasswordParams];
        params[@"username"] = self.accountText.text;
        params[@"password"] = self.passwordText.text;
        
        [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
            MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
            if (code.success) {
                [SVProgressHUD showSuccessWithStatus:@"重置成功"];
                [User userWithJSON:code.data[@"user_info"] completion:^{
                    [MUINotificationCenter postNotificationName:MUIDidLoginNotification object:nil userInfo:nil];
                    [self dismissViewControllerAnimated:NO completion:nil];
                }];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"重置失败"];
            }
        } failure:^(NSError *err) {
            [SVProgressHUD showSuccessWithStatus:@"网络不给力啊"];
        }];
    }
}

- (BOOL)checkRegisterInfo {
    if (!self.accountText.hasText) {
        [self.accountText shake];
        return NO;
    }
    if (!self.authCodeText.hasText) {
        [self.authCodeText shake];
        return NO;
    }
    if (!self.passwordText.hasText) {
        [self.passwordText shake];
        return NO;
    }
    if (self.passwordText.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码不能少于6位"];
        return NO;
    }
    if ([self.authCodeText.text isEqualToString:self.authCode]) {
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [MUINotificationCenter removeObserver:self];
}

@end
