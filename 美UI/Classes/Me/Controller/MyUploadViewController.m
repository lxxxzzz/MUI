//
//  MyUploadViewController.m
//  美UI
//
//  Created by Lee on 17/3/13.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "MyUploadViewController.h"
#import "HTTPTool.h"
#import "User.h"
#import "Item.h"
#import "MyUploadHeaderView.h"
#import "FavoriteCell.h"
#import "MyFlowLayout.h"
#import "MUIBaseViewController.h"
#import "MUIMeCollectItem.h"
#import "DetailViewController.h"
#import "MUINavigationViewController.h"
#import "Upload.h"
#import "MUINoResultView.h"
#import <Masonry.h>
#import <MJRefresh.h>

@interface MyUploadViewController () <UICollectionViewDelegate, UICollectionViewDataSource, MyFlowLayoutDelegate, MyUploadHeaderViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MUINoResultView *noResult;

@end

@implementation MyUploadViewController

static NSString * const kHeaderIdentifier = @"kHeaderIdentifier";
static NSString * const kReuseIdentifier = @"kReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setupSubviews {
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.collectionView addSubview:self.noResult];
    [self.noResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 161));
        make.centerX.mas_equalTo(self.collectionView.mas_centerX);
        make.centerY.mas_equalTo(self.collectionView.mas_centerY);
    }];
}

#pragma mark - overload
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Upload *upload = self.dataSource[section];
    NSInteger minCount = MIN(upload.items.count, 3);
    return minCount;
}

- (FavoriteCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    Upload *upload = self.dataSource[indexPath.section];
    cell.item = upload.items[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MyUploadHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        if (headerView.delegate == nil) headerView.delegate = self;
        headerView.upload = self.dataSource[indexPath.section];
        
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Upload *upload = self.dataSource[indexPath.section];
    DetailViewController *detail = [[DetailViewController alloc] init];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i=indexPath.item; i<upload.items.count; i++) {
        [arrM addObject:upload.items[i]];
    }
    detail.items = arrM;
    MUINavigationViewController *nav = (MUINavigationViewController *)self.navigationController;
    [nav pushViewController:detail hidesBottomBar:NO animated:YES];
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

#pragma mark - MyFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MyFlowLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    Upload *upload = self.dataSource[indexPath.section];
    Item *item = upload.items[indexPath.row];
    CGFloat height = width * item.pic_h / item.pic_w;
//    if (!item.cellHeight) {
//        item.cellHeight = height;
//    }
//    return item.cellHeight;
    return height;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(MyFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 30);
}

#pragma mark - MyUploadHeaderViewDelegate
- (void)headerViewShowMore:(MyUploadHeaderView *)headerView {
    MUIBaseViewController *baseVc = [[MUIBaseViewController alloc] init];
    baseVc.items = headerView.upload.items;
    baseVc.showNavigationBar = YES;
    baseVc.navigationItem.title = headerView.upload.title;
    [self.navigationController pushViewController:baseVc animated:YES];
}

- (void)loadData {
    self.noResult.hidden = YES;
    [self.dataSource removeAllObjects];
    NSString *url = [NSString stringWithFormat:@"%@?function=User/my_upload_list&mac=meiui&token=7b41408d1993764335d57232973934de&user_id=%@", MUIBaseUrl, USER.user_id];
    [HTTPTool GET:url params:nil success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            if (code.datas.count) {
                NSMutableArray *unpass_pic = [NSMutableArray array];
                NSMutableArray *pass_pic = [NSMutableArray array];

                for (NSDictionary *dict in code.data[@"items"][@"unpass_pic"]) {
                    Item *item = [[Item alloc] init];
                    item.pic = dict[@"pic_url"];
                    item.sys_tag = dict[@"pic_tag"];
                    item.brief = dict[@"pic_desc"];
                    item.app_name = dict[@"pic_app"];
                    item.pic_w = [dict[@"pic_w"] floatValue];
                    item.pic_h = [dict[@"pic_h"] floatValue];
                    item.user_name = dict[@"user_name"];
                    item.user_id = dict[@"user_id"];
                    [unpass_pic addObject:item];
                }
                
                for (NSDictionary *dict in code.data[@"items"][@"pass_pic"]) {
                    Item *item = [[Item alloc] init];
                    item.pic = dict[@"pic_url"];
                    item.sys_tag = dict[@"pic_tag"];
                    item.brief = dict[@"pic_desc"];
                    item.app_name = dict[@"pic_app"];
                    item.pic_w = [dict[@"pic_w"] floatValue];
                    item.pic_h = [dict[@"pic_h"] floatValue];
                    [pass_pic addObject:item];
                }
                Upload *unpass = [[Upload alloc] init];
                unpass.items = unpass_pic;
                unpass.title = @"待审核";
                
                Upload *pass = [[Upload alloc] init];
                pass.items = pass_pic;
                pass.title = @"已发表";
                if (pass_pic.count) [self.dataSource addObject:pass];
                if (unpass_pic.count) [self.dataSource addObject:unpass];
                [self.collectionView reloadData];
            }
        }
        self.noResult.hidden = (self.dataSource.count > 0);
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError *err) {
        [self.collectionView.mj_header endRefreshing];
        self.noResult.hidden = (self.dataSource.count > 0);
        [self.collectionView reloadData];
    }];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        MyFlowLayout *layout = [[MyFlowLayout alloc] init];
        layout.itemSpacing = 10;
        layout.lineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.colCount = 3;
        layout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = BG_COLOR;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FavoriteCell class] forCellWithReuseIdentifier:kReuseIdentifier];
        [_collectionView registerClass:[MyUploadHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (MUINoResultView *)noResult {
    if (_noResult == nil) {
        _noResult = [MUINoResultView noView];
        _noResult.imageView.image = [UIImage imageNamed:@"upload_is_empty"];
        _noResult.textLabel.text = @"没有收藏过任何图片";
        _noResult.hidden = YES;
    }
    return _noResult;
}

@end
