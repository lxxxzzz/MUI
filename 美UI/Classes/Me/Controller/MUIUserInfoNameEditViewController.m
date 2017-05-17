//
//  MUIUserInfoNameEditViewController.m
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIUserInfoNameEditViewController.h"
#import "MUIUserInfoEditCell.h"
#import "MUIHttpTool.h"
#import "MUIHttpParams.h"
#import "User.h"
#import "SVProgressHUD.h"

@interface MUIUserInfoNameEditViewController ()

@end

//http://meiui.me/api/index/?function=Login/edit_user&mac=meiui&token=7b41408d1993764335d57232973934de&username=15068159661&nickname=ap2ppp

@implementation MUIUserInfoNameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改名称";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    self.tableView.rowHeight = 44;
}

- (void)save {
    [SVProgressHUD showWithStatus:@"保存中..."];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MUIUserInfoEditCell *cell = (MUIUserInfoEditCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableDictionary *params = [MUIHttpParams editNameParams];
    if ([User isOnline]) {
        params[@"user_id"] = [User sharedUser].user_id;
    }
    params[@"nickname"] = cell.textField.text;
    [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            if (self.updateNameBlock) {
                self.updateNameBlock(cell.textField.text);
            }
            [User sharedUser].nickname = cell.textField.text;
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
 
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"(最多10个字，超出的将被忽略)";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MUIUserInfoEditCell *cell = [MUIUserInfoEditCell cellWithTableView:tableView];
    cell.textField.text = self.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
