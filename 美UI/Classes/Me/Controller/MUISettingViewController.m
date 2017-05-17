//
//  MUISettingViewController.m
//  美UI
//
//  Created by Lee on 16-2-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUISettingViewController.h"
#import "MUISettingItem.h"
#import "MUIMeSettingFooterView.h"
#import "UIImage+Stretch.h"
#import "UIImageView+WebCache.h"
#import "MUIFeedbackViewController.h"
#import "MUIAboutViewController.h"
#import "MUIUserInfoViewController.h"
#import "User.h"
#import "MUICacheTool.h"
#import <SVProgressHUD.h>

@interface MUISettingViewController () <MUIMeSettingFooterViewDelegate>

@property (nonatomic, strong) NSArray *items;

@end

@implementation MUISettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = RGB(241, 241, 241);
    MUIMeSettingFooterView *footer = [MUIMeSettingFooterView settingFooter];
    footer.delegate = self;
    footer.cacheSize = [[SDImageCache sharedImageCache] getSize];
    self.tableView.tableFooterView = footer;
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
}

- (void)dealloc {
    [MUINotificationCenter removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    MUISettingItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MUISettingItem *item = self.items[indexPath.row];
    if (item.option) {
        item.option();
    } else if (item.destVc) {
        UIViewController *vc = [[item.destVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 150.0;
}

- (void)settingFooterView:(MUIMeSettingFooterView *)footer clearCache:(UIButton *)clear {
    if ([[SDImageCache sharedImageCache] getSize] == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有缓存可以清理"];
        return;
    }
    [SVProgressHUD showWithStatus:@"清理中..."];
    [[SDImageCache sharedImageCache] clearDisk];
    
    [MUICacheTool deleteAllData];
    
    footer.cacheSize = [[SDImageCache sharedImageCache] getSize];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"清理成功"];
    });
}

- (void)settingFooterView:(MUIMeSettingFooterView *)footer logout:(UIButton *)logout {
    if ([User isOnline]) {
        [User logout];
        [SVProgressHUD showSuccessWithStatus:@"注销成功"];
        [MUINotificationCenter postNotificationName:MUIUserDidLogoutNotification object:nil userInfo:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

- (NSArray *)items {
    if (!_items) {
        MUISettingItem *userInfo = [MUISettingItem itemWithTitle:@"个人资料" destVc:[MUIUserInfoViewController class]];
        MUISettingItem *feedback = [MUISettingItem itemWithTitle:@"意见反馈" destVc:[MUIFeedbackViewController class]];
        MUISettingItem *about = [MUISettingItem itemWithTitle:@"关于" destVc:[MUIAboutViewController class]];
        MUISettingItem *grade = [MUISettingItem itemWithTitle:@"给我评分" destVc:nil];
        grade.option = ^{
            NSString *urlStr = @"itms-apps://itunes.apple.com/app/id1101633743";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        };
        
        _items = @[userInfo, feedback, about, grade];
    }
    return _items;
}

@end
