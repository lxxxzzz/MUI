//
//  DetailViewController.m
//  美UI
//
//  Created by Lee on 16/11/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "MUILoginViewController.h"
#import "MUIAddTagViewController.h"
#import "HTTPTool.h"
#import "MUIHttpParams.h"
#import "MUICacheTool.h"
#import <Masonry.h>
#import "DetailCell.h"
#import <MJExtension.h>
#import "BasePopTransitioning.h"
#import "MUIBaseViewController.h"

#import "RightRefresh.h"
#import "User.h"

#import "HomeViewController.h"
#import "MUIPhotoAuthViewController.h"
#import "MUINavigationViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <SVProgressHUD.h>

#import "MUIHomeUserInfoView.h"

#import "HomeViewModel.h"
#import "Error.h"
#import "ToolBar.h"

@interface DetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, DetailCellDelegatge, ToolBarDelegate>

@property (nonatomic, strong) BasePopTransitioning *popTransitioning;
@property (nonatomic, strong) RightRefresh *refresh;
@property (nonatomic, strong) ToolBar *toolBar;

@end

@implementation DetailViewController

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BG_COLOR;
    
    [self setupSubviews];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    
    Item *item = self.items[self.selectedIndex];
    self.toolBar.collectButton.selected = item.is_like == 1;
    
//    [self getDetailData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 先隐藏，不然头像出来的时候太丑，动画执行完了再取消隐藏
//    DetailCell *cell = (DetailCell *)[self.collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.userView.hidden = YES;
    
    [self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
//        cell.userView.hidden = NO;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 私有方法
#pragma mark 布局
- (void)setupSubviews {
    [self.view addSubview:self.collectView];
    [self.view addSubview:self.toolBar];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(60);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(49);
    }];
}

- (void)cancel {
    [self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(60);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutSubviews];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Action
- (void)modifyTag {
    // 检查用户是否登录过
    if ([User isOnline]) {
        [self jump2EditTagVc];
    } else {
        [self jump2LoginVc];
    }
}

- (void)saveImage {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        //无权限
        MUIPhotoAuthViewController *authVc = [[MUIPhotoAuthViewController alloc] init];
        authVc.type = MUIPhotoAuthViewControllerTypeCameraAuth;
        authVc.modal = YES;
        [self presentViewController:authVc animated:YES completion:nil];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        DetailCell *cell = (DetailCell *)[self.collectView cellForItemAtIndexPath:indexPath];
        UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)collect:(UIButton *)btn {
    if ([User isOnline]) {
        btn.selected = !btn.isSelected;
        Item *item = self.items[self.selectedIndex];
        if (btn.isSelected) {
            NSString *url = [NSString stringWithFormat:@"%@/?function=User/add_collection&mac=meiui&token=7b41408d1993764335d57232973934dee&user_id=%@&pic_id=%@",kURL, USER.user_id, item.pic_id];
            [self collect:url success:^{
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                item.is_like = 1;
            } failure:^{
                [SVProgressHUD showErrorWithStatus:@"收藏失败"];
                btn.selected = NO;
                item.is_like = 2;
            }];
        } else {
            // 取消收藏
            NSString *url = [NSString stringWithFormat:@"%@/?function=User/del_collection&mac=meiui&token=7b41408d1993764335d57232973934de&user_id=%@&pic_id=%@", kURL, USER.user_id, item.pic_id];
            [self collect:url success:^{
                [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
                item.is_like = 2;
            } failure:^{
                [SVProgressHUD showErrorWithStatus:@"取消失败"];
                btn.selected = YES;
                item.is_like = 1;
            }];
        }
    } else {
        [self jump2LoginVc];
    }
}

- (void)collect:(NSString *)url success:(void(^)())success failure:(void(^)())failure{
    [HTTPTool GET:url params:nil success:^(id json) {
        if ([json[@"alert"][@"msg"] isEqualToString:@"成功请求"]) {
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *err) {
        if (failure) {
            failure();
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"已保存到相册"];
    }
}

- (void)jump2EditTagVc {
    MUIAddTagViewController *tagVc = [[MUIAddTagViewController alloc] init];
    MUINavigationViewController *nav = [[MUINavigationViewController alloc] initWithRootViewController:tagVc];
    Item *item = self.items[self.selectedIndex];
    tagVc.myAllTags = item.user_tag_history;
    tagVc.myTags = item.user_tag;
    tagVc.recommendTag = item.sys_tag;
    tagVc.pic_id = item.pic_id;
    __weak typeof(self) weakSelf = self;
    tagVc.finishBlock = ^(NSArray *tags) {
        // 将新添加的tag放到详情页显示
        item.user_tag = [NSMutableArray arrayWithArray:tags];
        [weakSelf.collectView reloadData];
        
        // 将新添加的tag添加到user单例中
        [[[User sharedUser].tags mutableCopy] addObjectsFromArray:tags];
    };
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)jump2LoginVc {
    MUILoginViewController *login = [[MUILoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)getDetailData {
    NSMutableDictionary *params = [MUIHttpParams detailParams];
    Item *item = self.items[self.selectedIndex];
    params[@"pic_id"] = item.pic_id;
    if ([User isOnline]) {
        params[@"user_id"] = USER.user_id;
    }
    [HTTPTool GET:MUIBaseUrl params:params success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            Item *item = [Item mj_objectWithKeyValues:[code.data[@"items"] firstObject]];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)loadMoreData {
    // 当前页码加1
    self.model.page ++;
    
    if (self.model.page > self.model.totalPage) return;
    // 加载数据
    [self.model dataWithSuccess:^(NSArray *datas) {
        [self.items addObjectsFromArray:datas];
        HomeViewController *vc = (HomeViewController *)self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        [vc.items addObjectsFromArray:datas];;
        [vc.collectView reloadData];
        
        [self.collectView reloadData];
    } failure:^(Error *error) {
        // 加载跟个多不用加载离线数据
        [SVProgressHUD showErrorWithStatus:error.message];
        if (self.model.page > 1) self.model.page --;// 下拉失败，页码-1
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.refresh.frame = CGRectMake(SCREEN_WIDTH * self.items.count, 0, 70, SCREEN_HEIGHT);
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detail" forIndexPath:indexPath];
    if (cell.delegate == nil) {
        cell.delegate = self;
    }
    cell.item = self.items[indexPath.item];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectView) {
        // 左滑返回
        if (scrollView.contentOffset.x < -30) {
            [self cancel];
        }
        // 当前的index
        CGFloat doublePage = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.selectedIndex = (NSInteger)(doublePage + 0.5);
    }
    
    Item *item = self.items[self.selectedIndex];
    self.toolBar.collectButton.selected = item.is_like == 1;
}

#pragma mark - MUIDetailCellDelegatge
- (void)detailCellDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    static BOOL isShow = YES;
    static CGFloat lastOffset;
    CGFloat y = offset - lastOffset;
    CGFloat maxY = scrollView.contentSize.height - scrollView.frame.size.height;
    if (y > 50 && offset > 0 && scrollView.contentSize.height > self.view.bounds.size.height) {
        // 隐藏
        lastOffset = offset;
        if (isShow == YES) {
            isShow = NO;
            [self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(60);
            }];
        }
    }
    
    if (y < 0) {
        // 显示
        lastOffset = offset;
        if (isShow == NO && maxY > offset) {
            isShow = YES;
            [self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom);
            }];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutSubviews];
    }];
}

#pragma mark - ToolBarDelegate
- (void)toolBar:(ToolBar *)toolBar didClickButton:(UIButton *)btn atIndex:(NSInteger)index {
    switch (index) {
        case 0:
            // 返回
            [self cancel];
            break;
        case 1:
            // 收藏
            [self collect:btn];
            break;
        case 2:
            // 编辑
            [self modifyTag];
            break;
        case 3:
            // 保存到相册
            [self saveImage];
            break;
        default:
            break;
    }
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([toVC isKindOfClass:[MUIBaseViewController class]]) {
        return self.popTransitioning;
    } else {
        return nil;
    }
}

#pragma mark - setter and getter
#pragma mark setter
- (void)setItems:(NSMutableArray *)items {
    _items = items;
    
    [self.collectView reloadData];
}

#pragma mark getter
- (UICollectionView *)collectView {
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0f;
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.pagingEnabled = YES;
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.alwaysBounceHorizontal = YES;
        [_collectView registerClass:[DetailCell class] forCellWithReuseIdentifier:@"detail"];
    }
    return _collectView;
}

- (BasePopTransitioning *)popTransitioning {
    if (_popTransitioning == nil) {
        _popTransitioning = [[BasePopTransitioning alloc] init];
    }
    return _popTransitioning;
}

- (RightRefresh *)refresh {
    if (_refresh == nil) {
        _refresh = [[RightRefresh alloc] init];
        _refresh.scrollView = self.collectView;
        __weak typeof(self) weakSelf = self;
        _refresh.operation = ^ {
            [weakSelf loadMoreData];
        };
    }
    return _refresh;
}

- (ToolBar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[ToolBar alloc] init];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

@end
