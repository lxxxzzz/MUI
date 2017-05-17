//
//  MUIBaseViewController.m
//  美UI
//
//  Created by Lee on 16-2-29.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIBaseViewController.h"
#import "MUICollectionViewFlowLayout.h"
#import "DetailViewController.h"
#import "MUIHomeItem.h"
#import "NSString+MUIExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "NSString+MUIExtension.h"
#import "BasePushTransitioning.h"
#import "MUINavigationViewController.h"

#import "Item.h"
#import "BaseCell.h"

static NSString *const cellID = @"baseCellIdentifier";

@interface MUIBaseViewController () <UICollectionViewDataSource,UICollectionViewDelegate,MUICollectionViewFlowLayoutDelegate, UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) BasePushTransitioning *pushAnimation;

@end

@implementation MUIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectView];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.navigationController setNavigationBarHidden:!self.isShowNavigationBar animated:TRUE];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - UICollectionView delegate method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectView.mj_footer.hidden = (self.items.count == 0);
    return self.items.count;
}

- (BaseCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.item = self.items[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detail = [[DetailViewController alloc] init];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i=indexPath.item; i<self.items.count; i++) {
        [arrM addObject:self.items[i]];
    }
    detail.items = arrM;
    MUINavigationViewController *nav = (MUINavigationViewController *)self.navigationController;
    [nav pushViewController:detail hidesBottomBar:NO animated:YES];
}

#pragma mark - MUICollectionViewFlowLayout
- (CGFloat)waterFlow:(MUICollectionViewFlowLayout *)waterFlow heightForItem:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.items[indexPath.item];
    CGFloat height = width * item.pic_h / item.pic_w;
    if (item.cellHeight == 0) {
        CGFloat descH = [item.brief sizeWithText:CGSizeMake(width - 10, MAXFLOAT) font:[UIFont systemFontOfSize:8]].height;
        if (item.brief.length) {
            item.cellHeight = height + descH + 32 + 5;
        } else {
            item.cellHeight = height + 32;
        }
    }
    return item.cellHeight;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush && [toVC isKindOfClass:[DetailViewController class]]) {
        return self.pushAnimation;
    }else{
        return nil;
    }
}

- (BasePushTransitioning *)pushAnimation {
    if (_pushAnimation == nil) {
        _pushAnimation = [[BasePushTransitioning alloc] init];
    }
    return _pushAnimation;
}

- (UICollectionView *)collectView {
    if (_collectView == nil) {
        MUICollectionViewFlowLayout *layout = [[MUICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 180, 10);
        layout.rowMagrin = 10;
        layout.colMagrin = 10;
        layout.colCount = 2;
        layout.delegate = self;
        
        _collectView = [[MUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        [_collectView registerClass:[BaseCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectView;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
    
    [self.collectView reloadData];
}

@end
