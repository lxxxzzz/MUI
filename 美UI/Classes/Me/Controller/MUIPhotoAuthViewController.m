//
//  MUIPhotoAuthViewController.m
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIPhotoAuthViewController.h"

@interface MUIPhotoAuthViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *settingImage;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end

@implementation MUIPhotoAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = MUIPhotoAuthViewControllerTypePhotoLibraryAuth;
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"1.轻按此处，前往 美UI 设置"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    self.settingLabel.attributedText = content;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSetting)];
    self.settingLabel.userInteractionEnabled = YES;
    [self.settingLabel addGestureRecognizer:tap];
    
}

- (void)setType:(MUIPhotoAuthViewControllerType)type {
    _type = type;
    if (self.type == MUIPhotoAuthViewControllerTypePhotoLibraryAuth) {
        self.photoLabel.text = @"2.将照片设置为“开”";
        self.photoImage.image = [UIImage imageNamed:@"sys_photos"];
    } else {
        self.photoLabel.text = @"2.将相机设置为“开”";
        self.photoImage.image = [UIImage imageNamed:@"sys_camera"];
    }
}

- (void)toSetting {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

- (IBAction)cancel {
    if (self.isModal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
