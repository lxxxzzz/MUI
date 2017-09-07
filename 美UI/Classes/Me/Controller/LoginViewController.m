//
//  LoginViewController.m
//  美UI
//
//  Created by Lee on 16/8/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextField.h"
#import "Const.h"
#import <Masonry.h>
#import "MUIHttpTool.h"
#import "MUIHttpParams.h"
#import "SVProgressHUD.h"
#import "User.h"
#import "MUIResetPwdViewController.h"
#import "MUIHttpParams.h"
#import "MUIHTTPCode.h"
//#import "UMSocial.h"
#import "UITextField+Shake.h"
#import "DismissTranslation.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) LoginTextField *account;
@property (nonatomic, strong) LoginTextField *password;
@property (nonatomic, strong) UIButton *forgetPwd;
@property (nonatomic, strong) CAShapeLayer *layer;
@property (nonatomic, strong) DismissTranslation *dismissAnimation;

@end

@implementation LoginViewController

static CGFloat const kLoginBtnH = 57;

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupNotification];
}

- (void)dealloc {
    [MUINotificationCenter removeObserver:self];
}

#pragma mark - 私有方法
- (BOOL)canWeixinLogin {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

- (void)setupNotification {
    [MUINotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [MUINotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect kbRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat margin = CGRectGetMaxY(self.backView.frame) + 64 - kbRect.origin.y;
    if (margin <= 0) return;
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50 - margin);
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutSubviews];
    }];
}

- (BOOL)checkRegisterInfo {
    if (!self.account.textField.hasText) {
        [self.account.textField shake];
        return NO;
    }
    if (!self.password.textField.hasText) {
        [self.password.textField shake];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)loginOnClick {
    [self.view endEditing:YES];
    if (![self checkRegisterInfo]) return;
    // 发送登陆的网络请求
    [self startAnimationCompletion:^{
        NSMutableDictionary *params = [MUIHttpParams registerParams];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = self.account.textField.text;
        params[@"username"] = self.account.textField.text;
        params[@"password"] = self.password.textField.text;
        params[@"nickname"] = self.account.textField.text;
        [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
            MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
            if (code.success) {
                [User userWithJSON:code.data completion:^{
                    [MUINotificationCenter postNotificationName:MUIDidLoginNotification object:nil userInfo:nil];
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self stopAnimation];
                        !self.dismissCompletion ? : self.dismissCompletion();
                    }];
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:code.error];
                [self stopAnimation];
            }
        } failure:^(NSError *err) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力啊"];
            [self stopAnimation];
        }];
    }];
}

- (void)startAnimationCompletion:(void(^)())completion {
    [self.login mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kLoginBtnH);
        make.top.mas_equalTo(self.password.mas_bottom).offset(51);
        make.centerX.mas_equalTo(self.password.mas_centerX);
        make.height.mas_equalTo(kLoginBtnH);
    }];
    [self.login setTitle:@"" forState:UIControlStateNormal];
    self.login.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.login.layer.cornerRadius = kLoginBtnH * 0.5;
        self.login.layer.masksToBounds = YES;
        [self.login layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(kLoginBtnH/2, kLoginBtnH/2) radius:(kLoginBtnH/2 - 5) startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
        self.layer.frame = CGRectMake(0, 0, kLoginBtnH, kLoginBtnH);
        self.layer.path = path.CGPath;
        [self.login.layer addSublayer:self.layer];
        
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        baseAnimation.delegate = self;
        [self.login.layer addAnimation:baseAnimation forKey:@"RotationAnimation"];
        if (completion && finished) {
            completion();
        }
    }];
}

- (void)stopAnimation {
    self.login.userInteractionEnabled = YES;
    [self.login.layer removeAnimationForKey:@"RotationAnimation"];
    [self.layer removeFromSuperlayer];
    
    [self.login mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.password);
        make.top.mas_equalTo(self.password.mas_bottom).offset(51);
        make.centerX.mas_equalTo(self.password.mas_centerX);
        make.height.mas_equalTo(kLoginBtnH);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.login.layer.cornerRadius = kLoginBtnH / 2;
        self.login.layer.masksToBounds = YES;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.login setTitle:@"登录" forState:UIControlStateNormal];
    }];
}

- (void)forgetPasswordOnClick {
    MUIResetPwdViewController *restPwd = [[MUIResetPwdViewController alloc] init];
    [self.navigationController pushViewController:restPwd animated:YES];
}

#pragma mark - 微信登陆
- (void)weixinLogin {
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSMutableDictionary *params = [MUIHttpParams weixinParams];
//            params[@"username"] = snsAccount.unionId; // 唯一标识
//            params[@"user_pic"] = snsAccount.iconURL; // 头像
//            params[@"nickname"] = snsAccount.userName; // 昵称
//            [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
//                MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
//                if (code.success) {
//                    [User userWithJSON:code.data completion:^{
//                        [MUINotificationCenter postNotificationName:MUIDidLoginNotification object:nil userInfo:nil];
//                        [self dismissViewControllerAnimated:NO completion:self.dismissCompletion];
//                    }];
//                } else {
//                    [SVProgressHUD showErrorWithStatus:@"微信授权失败"];
//                }
//            } failure:^(NSError *err) {
//                [SVProgressHUD showErrorWithStatus:@"微信授权失败"];
//            }];
//        }
//    });
}

#pragma mark - setter and getter
- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (LoginTextField *)account {
    if (_account == nil) {
        _account = [[LoginTextField alloc] init];
        _account.placeholder = @"输入你的手机号";
        _account.image = @"icon_phone";
    }
    return _account;
}

- (LoginTextField *)password {
    if (_password == nil) {
        _password = [[LoginTextField alloc] init];
        _password.placeholder = @"输入密码";
        _password.image = @"icon_password";
        _password.textField.secureTextEntry = YES;
    }
    return _password;
}

- (UIButton *)forgetPwd {
    if (_forgetPwd == nil) {
        _forgetPwd = [[UIButton alloc] init];
        _forgetPwd.titleLabel.font = FONT(15);
        [_forgetPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPwd setTitleColor:RGB(79, 186, 160) forState:UIControlStateNormal];
        [_forgetPwd addTarget:self action:@selector(forgetPasswordOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwd;
}

- (UIButton *)login {
    if (_login == nil) {
        _login = [[UIButton alloc] init];
        _login.titleLabel.font = FONT(18);
        [_login setTitle:@"登录" forState:UIControlStateNormal];
        [_login setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [_login setBackgroundImage:[UIImage imageNamed:@"btn_bg_pressing"] forState:UIControlStateNormal];
        [_login setBackgroundImage:[UIImage imageNamed:@"btn_bg_pressed"] forState:UIControlStateHighlighted];
        [_login addTarget:self action:@selector(loginOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _login;
}

- (CAShapeLayer *)layer {
    if (_layer == nil) {
        _layer = [[CAShapeLayer alloc] init];
        _layer.lineWidth = 1;
        _layer.strokeColor = [UIColor whiteColor].CGColor;
        _layer.fillColor = self.login.backgroundColor.CGColor;
    }
    return _layer;
}

#pragma mark - setupSubviews
- (void)setupSubviews {
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.account];
    [self.backView addSubview:self.password];
    [self.backView addSubview:self.forgetPwd];
    [self.backView addSubview:self.login];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);
        make.bottom.mas_equalTo(self.login.mas_bottom);
    }];
    
    [self.account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top);
        make.left.mas_equalTo(self.backView.mas_left).offset(55);
        make.right.mas_equalTo(self.backView.mas_right).offset(-55);
        make.height.mas_equalTo(30);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.account.mas_bottom).offset(67);
        make.left.mas_equalTo(self.backView.mas_left).offset(55);
        make.right.mas_equalTo(self.backView.mas_right).offset(-55);
        make.height.mas_equalTo(30);
    }];
    
    [self.forgetPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.password.mas_bottom).offset(15);
        make.right.mas_equalTo(self.password.mas_right);
    }];
    
    [self.login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.password);
        make.top.mas_equalTo(self.password.mas_bottom).offset(51);
        make.centerX.mas_equalTo(self.password.mas_centerX);
        make.height.mas_equalTo(kLoginBtnH);
    }];
    
    UIImageView *leftLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_line"]];
    leftLine.hidden = ![self canWeixinLogin];
    UIImageView *rightLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_line"]];
    rightLine.hidden = ![self canWeixinLogin];
    UILabel *thirdLogin = [[UILabel alloc] init];
    thirdLogin.hidden = ![self canWeixinLogin];
    thirdLogin.text = @"第三方账号登录";
    thirdLogin.font = FONT(14);
    thirdLogin.textColor = RGB(211, 211, 211);
    UIButton *wxLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    wxLogin.hidden = ![self canWeixinLogin];
    [wxLogin setBackgroundImage:[UIImage imageNamed:@"login_weixin"] forState:UIControlStateNormal];
    [wxLogin addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftLine];
    [self.view addSubview:rightLine];
    [self.view addSubview:thirdLogin];
    [self.view addSubview:wxLogin];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.password.mas_left);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.login.mas_bottom).offset(44);
        make.width.mas_equalTo(rightLine.mas_width);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.password.mas_right);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.login.mas_bottom).offset(44);
    }];
    
    [thirdLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftLine.mas_centerY);
        make.left.mas_equalTo(leftLine.mas_right).offset(10);
        make.right.mas_equalTo(rightLine.mas_left).offset(10);
    }];
    
    [wxLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(thirdLogin.mas_bottom).offset(20);
    }];
}

@end
