//
//  MyFavoriteViewController.m
//  美UI
//
//  Created by Lee on 17/3/13.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "HTTPTool.h"
#import "User.h"
#import "Item.h"
#import "MUINavigationViewController.h"
#import "DetailViewController.h"
#import "MUINoResultView.h"
#import "FavoriteCell.h"
#import <MJRefresh.h>

@interface MyFavoriteViewController ()

@property (nonatomic, strong) MUINoResultView *noResut;

@end

@implementation MyFavoriteViewController

static NSString * const reuseIdentifier = @"FavoriteCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView.mj_header beginRefreshing];
    
    self.placeholder = self.noResut;
    
    [self.collectionView registerClass:[FavoriteCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.item = self.dataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detail = [[DetailViewController alloc] init];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i=indexPath.item; i<self.dataSource.count; i++) {
        [arrM addObject:self.dataSource[i]];
    }
    detail.items = arrM;
    MUINavigationViewController *nav = (MUINavigationViewController *)self.navigationController;
    [nav pushViewController:detail hidesBottomBar:NO animated:YES];
}

- (void)loadData {
    [self.dataSource removeAllObjects];
    NSString *url = [NSString stringWithFormat:@"%@?function=User/list_collection&mac=meiui&token=7b41408d1993764335d57232973934de&user_id=%@", MUIBaseUrl, USER.user_id];
    [HTTPTool GET:url params:nil success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            if (code.datas.count) {
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dict in code.datas) {
                    Item *item = [[Item alloc] init];
                    item.app_id = dict[@"app_id"];
                    item.pic_id = dict[@"pic_id"];
                    item.sys_tag = dict[@"sys_tag"];
                    item.app_name = dict[@"app_name"];
                    item.pic_w = [dict[@"pic_w"] doubleValue];
                    item.brief = dict[@"brief"];
                    item.user_pic = dict[@"user_pic"];
                    item.user_id = dict[@"user_id"];
                    item.pic = dict[@"pic"];
                    item.user_name = dict[@"user_name"];
                    item.user_tag = dict[@"user_tag"];
                    item.pic_h = [dict[@"pic_h"] doubleValue];
                    item.is_like = 1;
                    [arrM addObject:item];
                }
                self.dataSource = arrM;
            }
        }
        
        [self.collectionView reloadData];
        self.noResut.hidden = self.dataSource.count;
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError *err) {
        self.noResut.hidden = self.dataSource.count;
        [self.collectionView reloadData];
    }];
}

- (MUINoResultView *)noResut {
    if (_noResut == nil) {
        _noResut = [MUINoResultView noView];
        _noResut.imageView.image = [UIImage imageNamed:@"tags_is_empty"];
        _noResut.textLabel.text = @"没有收藏过任何图片";
    }
    return _noResut;
}

@end
