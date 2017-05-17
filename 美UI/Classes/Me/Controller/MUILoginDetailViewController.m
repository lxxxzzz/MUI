//
//  MUILoginDetailViewController.m
//  美UI
//
//  Created by Lee on 16-4-18.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUILoginDetailViewController.h"
#import "MUIHttpTool.h"
#import "MUIHttpParams.h"
#import "SVProgressHUD.h"
#import "MUIResetPwdViewController.h"
#import "MUIHttpParams.h"
#import "MUIHTTPCode.h"
#import "UMSocial.h"
#import "UITextField+Shake.h"
#import "User.h"

@interface MUILoginDetailViewController () <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewCenterYConstraint;
@property (weak, nonatomic) IBOutlet UIButton *weixinLogin;
@property (weak, nonatomic) IBOutlet UIImageView *leftLine;
@property (weak, nonatomic) IBOutlet UIImageView *rightLine;
@property (weak, nonatomic) IBOutlet UILabel *thirdPartLabel;

@end

@implementation MUILoginDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MUINotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [MUINotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.autoresizingMask = NO;
    self.weixinLogin.hidden = ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    self.thirdPartLabel.hidden = self.weixinLogin.hidden;
    self.leftLine.hidden = self.weixinLogin.hidden;
    self.rightLine.hidden = self.weixinLogin.hidden;

}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect kbRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 还有导航栏的高度
    CGFloat maxY = kbRect.size.height - (SCREEN_HEIGHT * 0.5 - 105) + 44;
    self.backViewCenterYConstraint.constant = MAX(maxY, 50) ;
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    self.backViewCenterYConstraint.constant = 50;
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutSubviews];
    }];
}

- (BOOL)checkRegisterInfo {
    if (!self.accountText.hasText) {
        [self.accountText shake];
        return NO;
    }
    if (!self.passwordText.hasText) {
        [self.passwordText shake];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginOnClick {
    if ([self checkRegisterInfo]) {
        // 发送登陆的网络请求
        // 发送注册请求
        NSMutableDictionary *params = [MUIHttpParams registerParams];
        params[@"mobile"] = self.accountText.text;
        params[@"username"] = self.accountText.text;
        params[@"password"] = self.passwordText.text;
        params[@"nickname"] = self.accountText.text;
        
        [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
            MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
            NSLog(@"%@",json);
            if (code.success)
            {
                [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
                
                [User userWithJSON:code.data completion:^{
                    [MUINotificationCenter postNotificationName:MUIDidLoginNotification object:nil userInfo:nil];
                    [self dismissViewControllerAnimated:NO completion:nil];
                }];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:code.error];
            }
        } failure:^(NSError *err) {
            [SVProgressHUD showSuccessWithStatus:@"网络不给力啊"];
        }];
    }
}

- (IBAction)forgetPasswordOnClick {
    MUIResetPwdViewController *restPwd = [[MUIResetPwdViewController alloc] init];
    [self.navigationController pushViewController:restPwd animated:YES];
}

- (IBAction)weixinLogin:(id)sender forEvent:(UIEvent *)event {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            [self addUsers:dict[@"wxsession"]];

//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }
    });
}

#pragma mark - 微信登陆
- (void)addUsers:(UMSocialAccountEntity *)account {
    NSMutableDictionary *params = [MUIHttpParams weixinParams];
    params[@"username"] = account.unionId; // 唯一标识
    params[@"user_pic"] = account.iconURL; // 头像
    params[@"nickname"] = account.userName; // 昵称
    [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            [User userWithJSON:code.data completion:^{
                [MUINotificationCenter postNotificationName:MUIDidLoginNotification object:nil userInfo:nil];
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"微信授权失败"];
        }
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"微信授权失败"];
    }];
}

- (void)dealloc
{
    [MUINotificationCenter removeObserver:self];
}


@end
