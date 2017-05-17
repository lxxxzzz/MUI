//
//  MUISearchResutsViewController.m
//  美UI
//
//  Created by Lee on 15-12-29.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUISearchResutsViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
#import "Item.h"
#import "MUISearchHeaderView.h"
#import "MUISearchTableCell.h"
#import "MUISearchTableFooterView.h"
#import "MBProgressHUD+MJ.h"
#import "MUIHTTPCode.h"
#import "MUINoResultView.h"
#import "MUISearchBar.h"
#import "User.h"
#import "MUIHttpTool.h"
#import "MUIHttpParams.h"

#import <MJExtension.h>

@interface MUISearchResutsViewController () <UISearchBarDelegate, SearchTableCellDelegate, SearchTableFooterViewDelegate>

@property (nonatomic, strong) MUISearchBar *searchBar;

/**
 *  没有数据展示的view
 */
@property (nonatomic, strong) MUINoResultView *noResut;

@end

@implementation MUISearchResutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitleView:self.searchBar];

    [self search];
    
    self.collectView.backgroundColor = RGB(241, 241, 241);

    self.searchBar.text = self.searchText;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
}

- (void)search {
    self.items = [NSMutableArray array];
    NSMutableDictionary *params = [MUIHttpParams searchResultParams];
    params[@"keyword"] = self.searchBar.text;
    if ([User isOnline]) {
        params[@"user_id"] = [User sharedUser].user_id;
    }
    [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            if (code.datas.count) {
//                NSMutableArray *arrM = [NSMutableArray array];
//                for (NSDictionary *dict in code.datas)
//                {
//                    Item *item = [Item itemWithDict:dict];
//                    [self.items addObjectsFromArray:[Item mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]]];
//                    item.user_tag_history = code.data[@"user_tag_history"];
//                    [arrM addObject:item];
//                }
                
//                self.items = [Item mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
                for (NSDictionary *dict in json[@"data"][@"items"]) {
                    Item *item = [Item mj_objectWithKeyValues:dict];
                    item.user_tag_history = json[@"data"][@"user_tag_history"];
                    [self.items addObject:item];
                }
            } else {
                
            }
            [self.collectView reloadData];
        } else {
            //            [MBProgressHUD showError:@"请求失败" toView:self.view];
        }
        self.noResut.hidden = (self.items.count > 0);
        self.noResut.textLabel.text = [NSString stringWithFormat:@"没有搜到与“%@”相关的结果",self.searchBar.text];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"网络不给力啊" toView:self.view];
    }];
}

#pragma mark - UISearchBar代理方法
#pragma mark 点击虚拟键盘上的搜索时
- (void)searchBarSearchButtonClicked:(MUISearchBar *)searchBar {
    // 1、放弃第一响应者对象，关闭虚拟键盘
    [searchBar resignFirstResponder];
    // 2、开始搜索
    [self search];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

- (MUINoResultView *)noResut {
    if (!_noResut) {
        _noResut = [MUINoResultView noView];
        _noResut.imageView.image = [UIImage imageNamed:@"search_is_empty"];
        _noResut.hidden = YES;
        [self.view addSubview:_noResut];
        [_noResut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 161));
            make.top.equalTo(self.view.mas_top).offset(100);
            make.left.mas_equalTo((SCREEN_WIDTH - 300) / 2);
        }];
    }
    return _noResut;
}

- (MUISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MUISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.text = self.searchText;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _searchBar;
}

@end
