//
//  PhotoListViewController.m
//  美UI
//
//  Created by Lee on 17/2/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoGroupViewController.h"
#import "Photo.h"
#import "PhotoGroup.h"
#import "ReleaseViewController.h"
#import "PhotoListCell.h"
#import "UIBarButtonItem+MUIExtension.h"
#import <Photos/Photos.h>
#import <Masonry.h>

const CGFloat imageSpacing = 4.0f;  /**< 图片间距 */
const NSInteger maxCountInLine = 4; /**< 每行显示图片张数 */

@interface PhotoListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSMutableArray    *selectedAssets;
@property (nonatomic, strong) UIButton          *finishButton;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, strong) PHFetchResult <PHAsset *> *result;

@end

@implementation PhotoListViewController

static NSString *const cellId = @"photoListCell";

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.result.count == 0 ) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.result.count - 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",[self class]);
}

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self action:@selector(clickBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
}

- (void)setupSubviews {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

//#pragma mark - ---------------------- animation
//- (void)showFinishButton{
//    self.finishButton.hidden = NO;
//    [UIView animateWithDuration:.25 animations:^{
//        CGRect frame = _finishButton.frame;
//        frame.origin.y = self.view.frame.size.height - frame.size.height;
//        _finishButton.frame = frame;
//        
//        frame = _collectionView.frame;
//        frame.size.height = _finishButton.frame.origin.y;
//        _collectionView.frame = frame;
//    }];
//    [_finishButton setTitle:[NSString stringWithFormat:@"已选%li张",_selectedCount] forState:UIControlStateNormal];
//}
//
//- (void)hideFinishButton{
//    [UIView animateWithDuration:0.25 animations:^{
//        CGRect frame = _finishButton.frame;
//        frame.origin.y = self.view.frame.size.height;
//        _finishButton.frame = frame;
//        
//        frame = _collectionView.frame;
//        frame.size.height = _finishButton.frame.origin.y;
//        _collectionView.frame = frame;
//    } completion:^(BOOL finished) {
//        self.finishButton.hidden = YES;
//    }];
//}

#pragma mark - Action
- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCancel{
    //    [self dismissViewControllerAnimated:NO completion:^{
    //        if (self.groupVC.delegate && [self.groupVC.delegate respondsToSelector:@selector(didSelectPhotos:)]) {
    //            NSMutableArray *photos = [NSMutableArray array];
    //            for (Photo *photo in self.photos) {
    //                if (photo.isSelected) {
    //                    [photos addObject:photo];
    //                }
    //            }
    //            [self.groupVC.delegate didSelectPhotos:photos];
    //        }
    //    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.result.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PhotoListCell alloc] init];
    }
    PHAsset *asset = self.result[indexPath.row];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:layout.itemSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.image = result;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.result[indexPath.row];
    ReleaseViewController *releaseVc = [[ReleaseViewController alloc] init];
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:0 resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        releaseVc.image = [UIImage imageWithData:imageData];
    }];
    [self.navigationController pushViewController:releaseVc animated:YES];
}

#pragma mark - setter and getter
- (void)setGroup:(PhotoGroup *)group {
    _group = group;
    
    [self.collectionView reloadData];
}

- (void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    
    self.result = [PHAsset fetchAssetsInAssetCollection:collection options:0];
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - imageSpacing * (maxCountInLine - 1)) / maxCountInLine;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing      = imageSpacing;
        layout.minimumInteritemSpacing = imageSpacing;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PhotoListCell class] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

- (NSMutableArray *)selectedAssets{
    if (_selectedAssets == nil) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}


@end
