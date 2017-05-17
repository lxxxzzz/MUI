//
//  MUIMeViewController.m
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUIMeViewController.h"
#import "UIImageView+WebCache.h"
#import "MUIMeHeaderView.h"
#import "MUISettingViewController.h"
#import "MUISegmentControl.h"
#import "MyCollectionViewController.h"
#import "Masonry.h"
#import "MUILoginViewController.h"
#import "AFNetworking.h"
#import "User.h"
#import "MUINavigationBar.h"
#import "MUIUserInfoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "DismissTranslation.h"
#import "MUIPhotoAuthViewController.h"
#import "ReleaseViewController.h"
#import "MUINavigationViewController.h"
#import "PhotoGroupViewController.h"
#import "Photo.h"
#import "UIBarButtonItem+MUIExtension.h"
#import "LoginViewController.h"

#import "MyBaseViewController.h"
#import "MyFavoriteViewController.h"
#import "MyUploadViewController.h"

@interface MUIMeViewController ()
<
UIScrollViewDelegate,
MUIMeHeaderViewDelegate,
MUISegmentControlDelegate,
UIViewControllerTransitioningDelegate,
PhotoGroupViewControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, strong) MUIMeHeaderView *backView;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, strong) MUISegmentControl *segment;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) MyCollectionViewController *collectVc;
@property (nonatomic, strong) MUINavigationBar *nav;
@property (nonatomic, strong) DismissTranslation *dismissAnimation;

@end

@implementation MUIMeViewController
#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
    
    [self setupChildVc];
    
    [self setupNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    
    if ([User isOnline]) { 
        [self userDidlogin];
#warning 加载message信息
    } else { // 没授权过，跳转到登陆界面
        MUILoginViewController *login = [[MUILoginViewController alloc] init];
        login.cancelBlock = ^{
            self.tabBarController.selectedIndex = 0;
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        nav.transitioningDelegate = self;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)dealloc {
    [MUINotificationCenter removeObserver:self];
}

#pragma mark - 私有方法
- (void)setupNotification {
    [MUINotificationCenter addObserver:self selector:@selector(userDidlogin) name:MUIDidLoginNotification object:nil];;
    [MUINotificationCenter addObserver:self selector:@selector(userDidLogout) name:MUIUserDidLogoutNotification object:nil];
}

- (void)setupSubviews {
    [self.view setBackgroundColor:BG_COLOR];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.segment];
    [self.view addSubview:self.scroll];
    [self.view addSubview:self.nav];
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.uploadButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@192);
    }];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@40);
    }];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

- (void)setupChildVc {
    MyFavoriteViewController *favoriteVc = [[MyFavoriteViewController alloc] init];
    MyUploadViewController *upload = [[MyUploadViewController alloc] init];
    MyCollectionViewController *collect = [[MyCollectionViewController alloc] init];
    favoriteVc.point = ^(CGFloat offsetY) {
        [self collectDidScrollowToPosition:offsetY];
    };
    upload.point = ^(CGFloat offsetY) {
        [self collectDidScrollowToPosition:offsetY];
    };
    collect.point = ^(CGFloat offsetY) {
        [self collectDidScrollowToPosition:offsetY];
    };
    
    [self addChildViewController:favoriteVc];
    [self addChildViewController:collect];
    [self addChildViewController:upload];
    [self scrollViewDidEndDecelerating:self.scroll];
}

- (void)userDidlogin {
    User *user = [User sharedUser];
    self.backView.userName.text = user.nickname;
    self.backView.iconImage.image = [UIImage imageWithData:user.userIcon];
    self.nav.title = user.nickname;
}

- (void)userDidLogout {
    self.tabBarController.selectedIndex = 0;
    self.backView.iconImage.image = [UIImage imageNamed:@"head_icon"];
    self.backView.userName.text = @"";
    self.nav.title = @"我";
}

- (void)login {
    MUIUserInfoViewController *info = [[MUIUserInfoViewController alloc] init];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)setting {
    MUISettingViewController *settingVc = [[MUISettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)upload {
    if ([User isOnline]) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
            // 无权限
            MUIPhotoAuthViewController *authVc = [[MUIPhotoAuthViewController alloc] init];
            authVc.type = MUIPhotoAuthViewControllerTypeCameraAuth;
            authVc.modal = YES;
            [self presentViewController:authVc animated:YES completion:nil];
        } else {
            // 有权限
            PhotoGroupViewController *groupVc = [[PhotoGroupViewController alloc] init];
            MUINavigationViewController *nav = [[MUINavigationViewController alloc] initWithRootViewController:groupVc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    } else {
        MUILoginViewController *loginVc = [[MUILoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        nav.transitioningDelegate = self;
        __weak typeof(self) weakSelf = self;
        loginVc.dismiss = ^{
            [weakSelf upload];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    //获取图片后的操作
    ReleaseViewController *releaseVc = [[ReleaseViewController alloc] init];
    releaseVc.image = image;
    [picker pushViewController:releaseVc animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController.navigationItem.leftBarButtonItem == nil && [navigationController.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:viewController.navigationController action:@selector(popViewControllerAnimated:)];
    }
}

- (void)back:(UIViewController *)vc {
    [vc.navigationController popViewControllerAnimated:YES];
}

- (void)collectDidScrollowToPosition:(CGFloat)offsetY {
    if (offsetY > 60) {
        [self backViewWillScrollToDown:NO];
    }

    if (offsetY < -60) {
        [self backViewWillScrollToDown:YES];
    }
}

- (void)backViewWillScrollToDown:(BOOL)down {
    CGFloat alpha = 0.0f;
    if (down) {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
        }];
    } else {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(-128);
        }];
        alpha = 1.0f;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.nav.alpha = alpha;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scroll) {
        int index = self.scroll.contentOffset.x / SCREEN_WIDTH;
        [self.segment setSelectedSegmentIndex:index animated:YES];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimation;
}

#pragma mark - MUISegmentControlDelegate
- (void)segmentControl:(MUISegmentControl *)segmentControl indexDidChange:(NSInteger)index {
    [self.scroll setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    
    UIViewController *vc = self.childViewControllers[index];
    [self.scroll addSubview:vc.view];
    
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scroll.mas_top);
        make.left.mas_equalTo(self.scroll.mas_left).offset(index * SCREEN_WIDTH);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(self.scroll.mas_height);
    }];
}

#pragma mark - 
- (void)didSelectPhotos:(NSMutableArray *)photos {
    ReleaseViewController *releaseVc = [[ReleaseViewController alloc] init];
    Photo *photo = [photos firstObject];
    releaseVc.image = photo.image;
    MUINavigationViewController *nav = [[MUINavigationViewController alloc] initWithRootViewController:releaseVc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - setter and getter
- (UIButton *)settingButton {
    if (_settingButton == nil) {
        _settingButton = [[UIButton alloc] initWithFrame:CGRectMake(10, (44 - 30) / 2 + 20, 30, 30)];
        [_settingButton setImage:[UIImage imageNamed:@"me_setting"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (UIButton *)uploadButton {
    if (_uploadButton == nil) {
        _uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, (44 - 30) / 2 + 20, 30, 30)];
        [_uploadButton setImage:[UIImage imageNamed:@"me_upload"] forState:UIControlStateNormal];
//        [_uploadButton setImage:[UIImage imageNamed:@"tools_edit_unclick"] forState:UIControlStateHighlighted];
        [_uploadButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadButton;
}

- (MUISegmentControl *)segment {
    if (_segment == nil) {
        _segment = [[MUISegmentControl alloc] initWithSectionTitles:@[@"喜欢", @"标签", @"发表"]];
        _segment.delegate = self;
    }
    return _segment;
}

- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] init];
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
        _scroll.bounces = NO;
        _scroll.alwaysBounceVertical = NO;
        _scroll.alwaysBounceHorizontal = NO;
        _scroll.delegate = self;
        _scroll.pagingEnabled = YES;
    }
    return _scroll;
}

- (MUIMeHeaderView *)backView {
    if (!_backView) {
        _backView = [[MUIMeHeaderView alloc] init];
        _backView.delegate = self;
    }
    return _backView;
}

- (DismissTranslation *)dismissAnimation {
    if (_dismissAnimation == nil) {
        _dismissAnimation = [[DismissTranslation alloc] init];
    }
    return _dismissAnimation;
}

- (MUINavigationBar *)nav {
    if (!_nav) {
        _nav = [[MUINavigationBar alloc] init];
        _nav.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    return _nav;
}

@end
