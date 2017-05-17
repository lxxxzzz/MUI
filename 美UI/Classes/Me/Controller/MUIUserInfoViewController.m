//
//  MUIUserInfoViewController.m
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIUserInfoViewController.h"
#import "MUIUserInfoItem.h"
#import "User.h"
#import "MUIUserInfoHeadCell.h"
#import "MUIUserInfoNameCell.h"
#import "MUIUserInfoNameEditViewController.h"
#import "MUIPhotoAuthViewController.h"
#import "MUIHttpParams.h"
#import "MUIHttpTool.h"
#import "SVProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface MUIUserInfoViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MUIUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    
    User *user = [User sharedUser];
    UIImage *icon = [UIImage imageWithData:user.userIcon];
    MUIUserInfoItem *headItem = [MUIUserInfoItem itemWithTitle:@"头像" name:nil icon:icon option:^{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [sheet showInView:self.view];
    }];

    MUIUserInfoItem *nameItem = [MUIUserInfoItem itemWithTitle:@"名字" name:user.nickname icon:nil option:^{
        MUIUserInfoNameEditViewController *edit = [[MUIUserInfoNameEditViewController alloc] init];
        edit.name = user.nickname;
        edit.updateNameBlock = ^(NSString *name)
        {
            MUIUserInfoItem *item = [self.dataSource lastObject];
            item.name = name;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:edit animated:YES];
    }];
    
    self.dataSource = @[headItem, nameItem];
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        MUIUserInfoItem *item = self.dataSource[indexPath.row];
        MUIUserInfoHeadCell *cell = [MUIUserInfoHeadCell cellWithTableView:tableView];
        cell.titleLabel.text = item.title;
        cell.iconImage.image = item.icon;
        return cell;
    }
    if (indexPath.row == 1)
    {
        MUIUserInfoItem *item = self.dataSource[indexPath.row];
        MUIUserInfoNameCell *cell = [MUIUserInfoNameCell cellWithTableView:tableView];
        cell.titleLabel.text = item.title;
        cell.nameLabel.text = item.name;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 65;
    }
    else
    {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MUIUserInfoItem *item = self.dataSource[indexPath.row];
    if (item.option)
    {
        item.option();
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // 相册
        [self jump2PhotoLibrary];
    }
    else if (buttonIndex == 1)
    {
        // 拍照
        [self jump2Camera];
    }
}

- (void)jump2Camera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        //无权限
        MUIPhotoAuthViewController *authVc = [[MUIPhotoAuthViewController alloc] init];
        authVc.type = MUIPhotoAuthViewControllerTypePhotoLibraryAuth;
        [self.navigationController pushViewController:authVc animated:YES];
    }
    else
    {
        UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
        pickerVc.allowsEditing = YES;
        pickerVc.delegate = self;
        pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerVc animated:YES completion:nil];
    }
}

- (void)jump2PhotoLibrary
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
    {
        //无权限
        MUIPhotoAuthViewController *authVc = [[MUIPhotoAuthViewController alloc] init];
        authVc.type = MUIPhotoAuthViewControllerTypeCameraAuth;
        [self.navigationController pushViewController:authVc animated:YES];
    }
    else
    {
        UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
        pickerVc.allowsEditing = YES;
        pickerVc.delegate = self;
        pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerVc animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *icon = info[UIImagePickerControllerEditedImage];
    
    [self uploadIcon:icon];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadIcon:(UIImage *)icon
{
    [SVProgressHUD showWithStatus:@"修改中..."];
    [MUIHttpTool POST:@"http://meiui.me/api/index/?function=Login/upload_pic&mac=meiui&token=7b41408d1993764335d57232973934de" params:nil image:icon success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success)
        {
            NSString *url = [NSString stringWithFormat:@"http://%@",code.data[@"img_url"]];
            [self updateUrl:url withIcon:icon];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

- (void)updateUrl:(NSString *)url withIcon:(UIImage *)icon
{
    NSMutableDictionary *params = [MUIHttpParams editNameParams];
    if ([User isOnline]) {
        params[@"user_id"] = [User sharedUser].user_id;
    }
    params[@"user_pic"] = url;
    [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success)
        {
            [SVProgressHUD showSuccessWithStatus:@"更新成功"];
            MUIUserInfoItem *item = [self.dataSource firstObject];
            item.icon = icon;
            [User sharedUser].icon = icon;
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"更新失败"];
        }
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

@end
