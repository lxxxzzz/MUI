//
//  HomeViewController.m
//  美UI
//
//  Created by Lee on 16/11/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "HomeViewController.h"
#import "MUIHomeItem.h"
#import <SVProgressHUD.h>
#import "User.h"
#import "MBProgressHUD+MJ.h"
#import "MUIHTTPCode.h"
#import "MUICacheTool.h"
#import "HTTPTool.h"
#import "MUIHttpParams.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "Item.h"
#import "HomeViewModel.h"
#import "Error.h"
#import "MUINavigationViewController.h"
#import "DetailViewController.h"
#import <SVProgressHUD.h>


@interface HomeViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong) HomeViewModel *model;

@end

@implementation HomeViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupStatusBar];
    
    [self setupCollectView];
    
    self.tabBarController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - 私有方法
- (void)setupStatusBar {
    UIView *statusView = [[UIView alloc] init];
    statusView.backgroundColor = RGB(219, 219, 219);
    statusView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [self.view addSubview:statusView];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)vc {
    if ([vc isEqual:tabBarController.selectedViewController]) {
        static NSTimeInterval lastClickTime;
        NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] - lastClickTime;
        if (time < 0.5) {
            // 点击相隔0.5s时算双击
            if (self.items.count) {
                [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }
        }
        lastClickTime = [NSDate timeIntervalSinceReferenceDate];
    }
    return YES;
}

#pragma mark - override
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detail = [[DetailViewController alloc] init];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i=indexPath.item; i<self.items.count; i++) {
        [arrM addObject:self.items[i]];
    }
    detail.items = arrM;
    detail.model = self.model;
    MUINavigationViewController *nav = (MUINavigationViewController *)self.navigationController;
    [nav pushViewController:detail hidesBottomBar:NO animated:YES];
}

- (void)setupCollectView {
    self.collectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.collectView.mj_header beginRefreshing];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData {
    // 当前页码加1
    self.model.page ++;
    
    if (self.model.page > self.model.totalPage) { // 如果当前页码大于最大页码，就隐藏上拉刷新
        self.collectView.mj_footer.hidden = YES;
        return;
    }
    // 加载数据
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.model dataWithSuccess:^(NSArray *datas) {
        [SVProgressHUD dismiss];
        [self.items addObjectsFromArray:datas];
        [self.collectView reloadData];
        [self.collectView.mj_footer endRefreshing];
    } failure:^(Error *error) {
        // 加载跟个多不用加载离线数据
        [SVProgressHUD showErrorWithStatus:error.message];

        if (self.model.page > 1) self.model.page --;// 下拉失败，页码-1
        
        // 结束刷新
        [self.collectView.mj_header endRefreshing];
        // 刷新表格
        [self.collectView reloadData];
    }];
}

/**
 *  加载最新数据
 */
- (void)loadNewData {
    [SVProgressHUD showWithStatus:@"加载中..."];
    // 初始化数组
    self.items = [NSMutableArray array];
    // 加载新的数据时，把当前页码初始化为1
    self.model.page = 1;
    [self.model dataWithSuccess:^(NSArray *datas) {
        [SVProgressHUD dismiss];
        self.items = [datas mutableCopy];
        // 缓存数据
        [MUICacheTool addItems:datas];
        [self.collectView.mj_header endRefreshing];
    } failure:^(Error *error) {
        if (error.type == ErrorTypeNetwork) {
            [SVProgressHUD showErrorWithStatus:@"网络连接失败，为您加载离线数据"];
            // 加载本地缓存数据
            [self loadCacheData];
        } else {
            [SVProgressHUD showErrorWithStatus:error.message];
        }
        [self.collectView.mj_header endRefreshing];
        // 刷新表格
        [self.collectView reloadData];
    }];
}

/**
 *  加载沙盒中的离线数据
 */
- (void)loadCacheData {
    NSArray *itemArray = [MUICacheTool items];
    if (itemArray.count) {
        [self.items addObjectsFromArray:itemArray];
        [self.collectView reloadData];
    }
}

- (HomeViewModel *)model {
    if (_model == nil) {
        _model = [[HomeViewModel alloc] init];
    }
    return _model;
}


@end
