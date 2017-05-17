//
//  MUISearchViewController.m
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUISearchViewController.h"
#import "UISearchBar+MUIExtension.h"
#import "MUISearchTableCell.h"
#import "MUISearchTableFooterView.h"
#import "MUICollectionViewFlowLayout.h"
#import "MUISearchCollectionViewCell.h"
#import "MUISearchResutsViewController.h"
#import "MUISphereView.h"
#import "MUISearchHeaderView.h"
#import "MUISearchBar.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MUIHttpTool.h"
#import "MUIHTTPCode.h"
#import "MUIHttpParams.h"

#define kBannerViewHeight 50.f

@interface MUISearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SearchTableCellDelegate, SearchTableFooterViewDelegate, MUISphereViewDelegate>

@property (nonatomic, strong) MUISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *historySearchWords;
@property (nonatomic, strong) UILabel *results;
@property (nonatomic, strong) MUISphereView *sphereView;

@end

@implementation MUISearchViewController

static NSString *const cellID = @"home";
static NSString *const kHistoryWord = @"history_words";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MUISearchHeaderView *headerView = [MUISearchHeaderView searchHeaderView];
    headerView.title.text = @"热门搜索";
    headerView.line.hidden = YES;
    
    [self.view addSubview:headerView];
    [self.view addSubview:self.sphereView];
    [self.view addSubview:self.tableView];
    [self.navigationItem setTitleView:self.searchBar];

    [self.historySearchWords addObjectsFromArray:[self getSandBox]];
    self.view.backgroundColor = BG_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
    
    [self loadHotSearchWords];
}

- (void)keyboardHide {
    [self.searchBar endEditing:YES];
    UIButton *btn = [self.searchBar valueForKey:@"_cancelButton"];
    btn.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.searchBar.text = nil;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self hideTableViewAnimation:NO];
}

- (MUISphereView *)sphereView {
    if (!_sphereView) {
        CGFloat sphereW = SCREEN_WIDTH - 100;
        CGFloat sphereH = sphereW;
        CGFloat sphereX = (SCREEN_WIDTH - sphereW) / 2;
        CGFloat sphereY = 50;
        CGRect rect = CGRectMake(sphereX, sphereY, sphereW, sphereH);
        _sphereView = [[MUISphereView alloc] initWithFrame:rect];
        _sphereView.delegate = self;
    }
    return _sphereView;
}


- (MUISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MUISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0, 340, 35);
        _searchBar.delegate = self;
        _searchBar.backgroundColor = self.navigationController.navigationBar.barTintColor;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.tableView setFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        MUISearchHeaderView *headerView = [MUISearchHeaderView searchHeaderView];
        headerView.title.text = @"历史搜索";
        _tableView.tableHeaderView = headerView;
        _tableView.backgroundColor = BG_COLOR;
    }
    return _tableView;
}

- (NSMutableArray *)historySearchWords {
    if (!_historySearchWords) {
        _historySearchWords = [NSMutableArray array];
    }
    return _historySearchWords;
}

- (UILabel *)results {
    if (!_results) {
        _results = [[UILabel alloc] init];
        _results.frame = CGRectMake(10, 300, SCREEN_WIDTH - 20, 20);
        _results.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_results];
    }
    return _results;
}

- (void)loadHotSearchWords {
    [MUIHttpTool GET:MUIBaseUrl params:[MUIHttpParams searchParams] success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            if (code.datas.count) {
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dict in code.datas) {
                    [arrM addObject:dict[@"tag_title"]];
                }
                self.sphereView.datas = arrM;
            } else {
                [MBProgressHUD showError:@"暂无热门搜索词" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:@"加载热门搜索失败" toView:self.view];
        }
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"加载热门搜索失败" toView:self.view];
    }];
}

#pragma mark - UISearchBar代理方法
#pragma mark searchBar开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // 1、显示cancel按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    // 2、设置cancel按钮的颜色
    UIButton *btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitleColor:RGB(171, 171, 171) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(171, 171, 171) forState:UIControlStateHighlighted];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    // 3、显示历史搜索tableView
    [self showTableView];
}

#pragma mark searchBar结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // 1、隐藏cancel按钮
//    [searchBar setShowsCancelButton:NO animated:YES];
    // 2、显示历史搜索tableView
//    [self hideTableView];
}

#pragma mark 点击虚拟键盘上的搜索时
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 1、放弃第一响应者对象，关闭虚拟键盘
    [searchBar resignFirstResponder];
    // 2、开始搜索
    [self search:searchBar.text];
    
    
}

#pragma mark 点击取消时
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    searchBar.text = nil;
//    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
    [self hideTableViewAnimation:YES];
}

#pragma mark - UITableView delegate methon
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historySearchWords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MUISearchTableCell *cell = [MUISearchTableCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.title.text = self.historySearchWords[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideTableViewAnimation:YES];
    [self search:self.historySearchWords[indexPath.row]];
}

#pragma mark - MUISearchTableCell delegate method
- (void)searchTableCellDeleteItem:(NSString *)title {
    // 1、将选中的词从历史搜索词数组中删除
    [self.historySearchWords removeObject:title];
    // 2、刷新表格
    [self showTableView];
    // 3、将新的历史搜索词数组存到沙盒
    [self saveToSandBox];
}


#pragma mark - MUISearchTableFooterView delegate method
- (void)clearAll {
    // 1、将历史搜索词数组清空
    [self.historySearchWords removeAllObjects];
    // 2、刷新表格
    [self.tableView reloadData];
    // 3、清空之后把footerView也清空
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    // 更新沙盒里的数据
    [self saveToSandBox];
}


- (void)search:(NSString *)str {
    if (![self.historySearchWords containsObject:str]) { // 如果历史搜索词数组中不包含用户输入的搜索词，则添加到历史搜索词数组中去
        if (self.historySearchWords.count >= 10) {
            [self.historySearchWords removeLastObject];
        }
        [self.historySearchWords insertObject:str atIndex:0];
        [self.tableView reloadData];
    } else {
        [self.historySearchWords removeObject:str];
        if (self.historySearchWords.count >= 10)
        {
            [self.historySearchWords removeLastObject];
        }
        [self.historySearchWords insertObject:str atIndex:0];
        [self.tableView reloadData];
    }
    // 保存到沙盒
    [self saveToSandBox];
    // 搜索框键盘退出
    [self.searchBar resignFirstResponder];
    
    MUISearchResutsViewController *result = [[MUISearchResutsViewController alloc] init];
    result.searchText = str;
    [self.navigationController pushViewController:result animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
    [self hideTableViewAnimation:YES];
}

- (void)showTableView {
    if (self.historySearchWords.count > 0) {
        MUISearchTableFooterView *footer = [MUISearchTableFooterView searchTableFooter];
        footer.delegate = self;
        self.tableView.tableFooterView = footer;
    } else {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }

    [UIView animateWithDuration:0.4 animations:^{
        [self.tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
    
    [self.tableView reloadData];
}

- (void)hideTableViewAnimation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.8 animations:^{
            [self.tableView setFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        }];
    } else {
        [self.tableView setFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    }
}

- (void)saveToSandBox {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.historySearchWords forKey:kHistoryWord];
    [defaults synchronize];
}

- (NSMutableArray *)getSandBox {
    NSArray *words = [[NSUserDefaults standardUserDefaults] objectForKey:kHistoryWord];
    return words ? words : [@[] mutableCopy];
}

#pragma mark - MUISearchHotWordsViewDelegate
- (void)searchHotWordsViewSelectedTitle:(UIButton *)button {
    self.searchBar.text = button.titleLabel.text;
    [self search:self.searchBar.text];
}

#pragma mark - MUISphereViewDelegate
- (void)sphereView:(MUISphereView *)sphereView selectedButton:(UIButton *)btn {
    self.searchBar.text = btn.titleLabel.text;
    [self search:self.searchBar.text];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 10) {
            [self.searchBar endEditing:YES];
            UIButton *btn = [self.searchBar valueForKey:@"_cancelButton"];
            btn.enabled = YES;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidHideNotification];
}

@end
