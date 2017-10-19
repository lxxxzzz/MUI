//
//  MUIMessageViewController.m
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUIMessageViewController.h"
#import "MUIMessageCell.h"
#import "MUIMessage.h"
#import "Masonry.h"
#import "User.h"
#import "MUILoginViewController.h"
#import "MUINoResultView.h"
#import "HTTPTool.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>

@interface MUIMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) MUINoResultView *noResut;

@end

@implementation MUIMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noResut];
    [self.noResut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 161));
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.mas_equalTo((SCREEN_WIDTH - 300) / 2);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 检查用户是否授权过
    if ([User isOnline]) { // 授权过
#warning 加载message信息
        [self.tableView.mj_header beginRefreshing];
    } else { // 没授权过，跳转到登陆界面
        MUILoginViewController *login = [[MUILoginViewController alloc] init];
        login.cancelBlock = ^{
            self.tabBarController.selectedIndex = 0;
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 网络请求
- (void)loadMessage {
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.noResut.hidden = YES;
    NSString *url = [NSString stringWithFormat:@"?function=Message/index&mac=meiui&token=7b41408d1993764335d57232973934de&user_id=%@&page=1",[User sharedUser].user_id];
    [HTTPTool GET:url success:^(id json) {
        NSMutableArray *messages = [NSMutableArray array];
        if ([json[@"alert"][@"msg"] isEqualToString:@"成功请求"]) {
            if (json[@"data"][@"items"]) {
                for (NSDictionary *dict in json[@"data"][@"items"]) {
                    MUIMessage *message = [[MUIMessage alloc] init];
                    message.messageContent = dict[@"msg"];
                    message.messageType = dict[@"msg_flag"];
                    message.messageImage = dict[@"msg_pic"];
                    message.messageTime = [dict[@"created_at"] longLongValue];
                    message.messageId = [dict[@"id"] integerValue];
                    [messages addObject:message];
                }
                self.messages = messages;
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        self.noResut.hidden = self.messages.count != 0;
        self.tableView.hidden = !self.noResut.hidden;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        self.noResut.hidden = self.messages.count != 0;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MUIMessageCell *cell = [MUIMessageCell cellWithTableView:tableView];
    cell.message = self.messages[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.messages removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (MUINoResultView *)noResut {
    if (!_noResut) {
        _noResut = [MUINoResultView noView];
        _noResut.imageView.image = [UIImage imageNamed:@"messagebox_is_empty"];
        _noResut.textLabel.text = @"当前还没有什么要禀报您的";
        _noResut.textLabel.font = [UIFont systemFontOfSize:14];
        _noResut.textLabel.textColor = RGB(110, 110, 110);
        _noResut.hidden = YES;
    }
    return _noResut;
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _tableView.backgroundColor = BG_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 84;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMessage)];
    }
    return _tableView;
}

@end
