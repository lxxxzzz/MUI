//
//  MUIAboutViewController.m
//  美UI
//
//  Created by Lee on 16-3-17.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIAboutViewController.h"
#import "MUIWeixinCodeViewController.h"


@interface MUIAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UIButton *weixin;

@end

@implementation MUIAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于我们";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.version.text = [NSString stringWithFormat:@"Version :%@",appVersion];
    self.weixin.layer.cornerRadius = 5;
    self.weixin.layer.masksToBounds = YES;
    self.weixin.layer.borderWidth = 1;
    self.weixin.layer.borderColor = [self.weixin.currentTitleColor CGColor];
}

- (IBAction)WXView
{
    MUIWeixinCodeViewController *codeVc = [[MUIWeixinCodeViewController alloc] init];
    codeVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:codeVc animated:YES completion:nil];
}
@end
