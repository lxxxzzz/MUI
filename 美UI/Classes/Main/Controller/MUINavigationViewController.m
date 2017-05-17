//
//  MUINavigationViewController.m
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUINavigationViewController.h"
#import "UIBarButtonItem+MUIExtension.h"

@interface MUINavigationViewController ()

@end

@implementation MUINavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
}


/**
 *  第一次使用这个类时会调用
 */
+ (void)initialize
{
    // 1、设置UINavigationBar的主题
    [self setupNavigationBarStyle];
    
    // 2、设置UIBarButtonItem的主题
    [self setupBarButtonItemStyle];
}


/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarStyle
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    // 隐藏导航栏下面的黑线
    [appearance setShadowImage:[[UIImage alloc] init]];
    UIColor *color = [NAV_BAR_COLOR colorWithAlphaComponent:1];
    [appearance setBackgroundImage:[self imageWithColor:color] forBarMetrics:UIBarMetricsDefault];

    // 设置文字属性
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = NAV_BAR_TITILE_COLOR;
    textAttrs[NSFontAttributeName] = NAV_BAR_FONT;
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
//    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemStyle
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];

}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController hidesBottomBar:(BOOL)hide animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = hide;
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}



@end
