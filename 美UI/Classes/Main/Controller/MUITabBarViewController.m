//
//  MUITabBarViewController.m
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUITabBarViewController.h"
#import "HomeViewController.h"
#import "MUIMessageViewController.h"
#import "MUIMeViewController.h"
#import "MUISearchViewController.h"
#import "MUINavigationViewController.h"

@interface MUITabBarViewController () <UITabBarControllerDelegate>

@property (nonatomic ,assign) NSInteger lastSelectedIndex;

@end

@implementation MUITabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // 1、添加子控制器
    [self addChildViewControllers];
}

- (void)addChildViewControllers{
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChlildViewController:home title:nil imageName:@"tab_home_no" selectedImageName:@"tab_home_yes"];
    
    MUISearchViewController *search = [[MUISearchViewController alloc] init];
    [self addChlildViewController:search title:nil imageName:@"tab_search_no" selectedImageName:@"tab_search_yes"];
    
    MUIMessageViewController *message = [[MUIMessageViewController alloc] init];
    [self addChlildViewController:message title:nil imageName:@"tab_message_no" selectedImageName:@"tab_message_yes"];
    
    MUIMeViewController *me = [[MUIMeViewController alloc] init];
    [self addChlildViewController:me title:nil imageName:@"tab_me_no" selectedImageName:@"tab_me_yes"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addChlildViewController:(UIViewController *)child title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    if (title.length) {
        // 有title，设置标题
        child.title = title;
    } else {   // 没有title，图片居中显示
        // 注意 top 和 bottom 的值要一样，否则出现放大缩小的情况
        child.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    // 设置图标
    child.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [child.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [child.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 图片用原图,不要别渲染
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    child.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    MUINavigationViewController *nav = [[MUINavigationViewController alloc] initWithRootViewController:child];
    [self addChildViewController:nav];
}


@end
