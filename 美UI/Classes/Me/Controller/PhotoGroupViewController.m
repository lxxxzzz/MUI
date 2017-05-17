//
//  PhotoGroupViewController.m
//  美UI
//
//  Created by Lee on 17/2/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoGroupViewController.h"
#import "PhotoGroupCell.h"
#import "PhotoListViewController.h"
#import "PhotoGroup.h"
#import "Photo.h"
#import "UIBarButtonItem+MUIExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Masonry.h>

@interface PhotoGroupViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray    *groupList;
@property (strong, nonatomic) UITableView       *tableView;

@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *result;

@end

@implementation PhotoGroupViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    [self getAllGroup];
}

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self action:@selector(clickBack)];
    self.navigationItem.title = @"相薄";
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushWithCollection:(PHAssetCollection *)collection animated:(BOOL)animated {
    PhotoListViewController *photoListVC = [[PhotoListViewController alloc] init];
    photoListVC.groupVC = self;
    photoListVC.collection = collection;
    photoListVC.navigationItem.title = collection.localizedTitle;
    [self.navigationController pushViewController:photoListVC animated:animated];
}

//获取所有相薄
- (void)getAllGroup{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 遍历所有的自定义相册
            self.result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

            [self.tableView reloadData];
            
            for (PHAssetCollection *collection in self.result) {
                if ([collection.localizedTitle isEqualToString:@"相机胶卷"] || [collection.localizedTitle isEqualToString:@"Camera Roll"]) {
                    [self pushWithCollection:collection animated:NO];
                    break;
                }
            }
        });
    }];
//    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - delegate
#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    PhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PhotoGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    PHAssetCollection *collection = self.result[indexPath.row];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:0];
    //显示相薄名称+图片张数
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",collection.localizedTitle, result.count];
    return cell;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PHAssetCollection *collection = self.result[indexPath.row];
    
    [self pushWithCollection:collection animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.layoutMargins = cell.layoutMargins;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.separatorInset = cell.separatorInset;
    }
}

#pragma mark - setter and getter
#pragma mark getter
- (NSMutableArray *)groupList{
    if (_groupList == nil) {
        _groupList = [[NSMutableArray alloc] init];
    }
    return _groupList;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
