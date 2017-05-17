//
//  MyCollectionViewController.m
//  美UI
//
//  Created by Lee on 17/3/13.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MUINoResultView.h"
#import "MUICollectionViewFlowLayout.h"
#import "HTTPTool.h"
#import "MUIHttpParams.h"
#import "MUIMeCollectItem.h"
#import <MJRefresh.h>

#import "MUIMyCollectViewController.h"

@interface MyCollectionViewController ()

@property (nonatomic, strong) MUINoResultView *noResut;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView.mj_header beginRefreshing];
    
    self.placeholder = self.noResut;
}

- (void)userDidlogin {
    self.collectionView.mj_header.hidden = NO;
    [self.collectionView.mj_header beginRefreshing];
}

- (void)userDidLogout {
    self.collectionView.mj_header.hidden = YES;
    [self.dataSource removeAllObjects];
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MUIMyCollectViewController *my = [[MUIMyCollectViewController alloc] init];
    my.collect = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:my animated:YES];
}

#pragma mark - MUICollectionViewFlowLayout
- (CGFloat)waterFlow:(MUICollectionViewFlowLayout *)waterFlow heightForItem:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    return width * 176 / 90.0;
}

- (void)loadData {
    [self.dataSource removeAllObjects];
    [HTTPTool GET:MUIBaseUrl params:[MUIHttpParams collectParams] success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            if (code.tags.count) {
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dict in code.tags) {
                    MUIMeCollectItem *item = [MUIMeCollectItem itemWithDict:dict withTag:code.data[@"user_tag_history"]];
                    [arrM addObject:item];
                }
                self.dataSource = arrM;
            }
        }
        self.noResut.hidden = (self.dataSource.count > 0);
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError *err) {
        self.noResut.hidden = (self.dataSource.count > 0);
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (MUINoResultView *)noResut {
    if (_noResut == nil) {
        _noResut = [MUINoResultView noView];
        _noResut.imageView.image = [UIImage imageNamed:@"tags_is_empty"];
        _noResut.textLabel.text = @"没有标记过任何图片";
    }
    return _noResut;
}

@end
