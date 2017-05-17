//
//  MyBaseViewController.m
//  美UI
//
//  Created by Lee on 17/3/13.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "MyBaseViewController.h"
#import "MUICollectionViewFlowLayout.h"
#import "MyBaseCell.h"
#import "Item.h"
#import "MUICollectionView.h"
#import <Masonry.h>
#import <MJRefresh.h>

@interface MyBaseViewController () <MUICollectionViewFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation MyBaseViewController

static NSString * const reuseIdentifier = @"MyBaseViewControllerCell";

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
    
    [self setupNotification];
}

- (void)dealloc {
    [MUINotificationCenter removeObserver:self];
}

- (void)setupNotification {
    [MUINotificationCenter addObserver:self selector:@selector(userDidlogin) name:MUIDidLoginNotification object:nil];;
    [MUINotificationCenter addObserver:self selector:@selector(userDidLogout) name:MUIUserDidLogoutNotification object:nil];
}

- (void)setupSubviews {
    [self.view addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    if (self.placeholder) {
        [self.collectionView addSubview:self.placeholder];
        [self.placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 161));
            make.centerX.mas_equalTo(self.collectionView.mas_centerX);
            make.centerY.mas_equalTo(self.collectionView.mas_centerY);
        }];
    }
}

- (void)userDidlogin {
    [self loadData];
}

- (void)userDidLogout {
    
}

- (void)loadData {
    // 让子类自己去实现
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (_point) {
            _point(offsetY);
        }
    }
}

#pragma mark - UICollectionView delegate method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.item = self.dataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - MUICollectionViewFlowLayout
- (CGFloat)waterFlow:(MUICollectionViewFlowLayout *)waterFlow heightForItem:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.dataSource[indexPath.item];
    CGFloat height = width * item.pic_h / item.pic_w;
    if (!item.cellHeight) {
        item.cellHeight = height;
    }
    return item.cellHeight;
}

#pragma mark - setter and getter
#pragma mark setter
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    [self.collectionView reloadData];
}

#pragma mark getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        MUICollectionViewFlowLayout *layout = [[MUICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 180, 10);
        layout.rowMagrin = 10;
        layout.colMagrin = 10;
        layout.colCount = 3;
        layout.delegate = self;
        _collectionView = [[MUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BG_COLOR;
        [_collectionView registerClass:[MyBaseCell class] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _collectionView;
}

@end
