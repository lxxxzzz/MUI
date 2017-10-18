//
//  ReleaseViewController.m
//  美UI
//
//  Created by Lee on 17/2/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ReleaseViewController.h"
#import "MUIHttpTool.h"
#import "TagViewController.h"
#import "User.h"
#import "MUICacheTool.h"
#import "UIImage+Stretch.h"
#import "MUITextView.h"
#import "MUINavigationViewController.h"
#import "UIBarButtonItem+MUIExtension.h"
#import "MUIHttpParams.h"
#import <Masonry.h>
#import <AliyunOSSiOS/OSSService.h>
#import <SVProgressHUD.h>

@interface ReleaseViewController () <TagViewControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *nameValue;
@property (nonatomic, strong) MUITextView *descValue;
@property (nonatomic, strong) UILabel *tagPlaceholder;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) NSString *strTags;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIButton *publish;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, weak) UIView *maskView;

@end

@implementation ReleaseViewController

static CGFloat const offset = 200;

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
//    [self setupNotifacation];
    
    [self setupNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    NSLog(@"ReleaseViewController被销毁");
    [MUINotificationCenter removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setupNavigationItem {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_back" highImageName:@"nav_back" target:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setupNotifacation {
    [MUINotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [MUINotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect kbRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y =  CGRectGetMaxY(self.backView.frame) - kbRect.origin.y + offset + 64;
    if (y < 0) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.backScrollView.contentOffset = CGPointMake(0, (-offset + y));
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [UIView animateWithDuration:0.25 animations:^{
        self.backScrollView.contentOffset = CGPointMake(0, -offset);
    }];
}

- (void)tagViewController:(TagViewController *)viewController didSelectTags:(NSArray *)tags {
    self.tags = tags;
    self.strTags = nil;
    // 先移除所有button
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.tagPlaceholder.hidden = tags.count;
    
    UIButton *last = nil;
    for (int i=0; i<tags.count; i++) {
        NSString *str = tags[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"upload_tag"] forState:UIControlStateNormal];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        [self.scrollView addSubview:btn];
        CGRect rect = btn.frame;
        rect.origin.y = (self.scrollView.frame.size.height - rect.size.height) / 2;
        if (i) {
            rect.origin.x = CGRectGetMaxX(last.frame) + 10;
        } else {
            rect.origin.x = CGRectGetMaxX(last.frame);
        }
        btn.frame = rect;
        last = btn;
        
        if (self.strTags) {
            self.strTags = [NSString stringWithFormat:@"%@,%@",self.strTags, str];
        } else {
            self.strTags = str;
        }
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(last.frame), 0);
}

- (void)selectTag {
    [self.nameValue resignFirstResponder];
    TagViewController *tagVc = [[TagViewController alloc] init];
    __weak typeof(tagVc) weakVc = tagVc;
    tagVc.delegate = self;
    tagVc.myTags = [User sharedUser].tags;
    tagVc.backEvent = ^(){
        [weakVc.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:tagVc animated:YES];
}

- (void)clickImage {
    UIView *maskView = [[UIView alloc] init];
    maskView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImage)];
    [maskView addGestureRecognizer:tap];
    imageView.image = self.imageView.image;
    
    CGRect rect = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    imageView.frame = rect;
    [maskView addSubview:imageView];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat x = 0;
        CGFloat w = SCREEN_WIDTH;
        CGFloat h = SCREEN_WIDTH * self.imageView.image.size.height / self.imageView.image.size.width;
        CGFloat y = (SCREEN_HEIGHT - h) / 2;
        imageView.frame = CGRectMake(x, y, w, h);
        maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }];
    self.maskView = maskView;
}

- (void)closeImage {
    UIImageView *imageView = [self.maskView.subviews firstObject];
    CGRect rect = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = rect;
        self.maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}

- (void)back {
    [self hideKeyboard];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"信息尚未保存，确定返回么？" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续编辑", nil];
    [alert show];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)finish {
    if (!self.nameValue.hasText) {
        [SVProgressHUD showErrorWithStatus:@"请输入名称"];
        return;
    }
    if (!self.strTags) {
        [SVProgressHUD showErrorWithStatus:@"请至少添加一个标签"];
        return;
    }
    [SVProgressHUD showWithStatus:@"上传中..."];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd-hh:mm:ss:SSS";
    NSString *date = [format stringFromDate:[NSDate date]];
    NSString *endpoint = @"oss-cn-shanghai.aliyuncs.com";
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.png", uuid, date];
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"s0WYfL4Mp6Nvw5pa" secretKey:@"EfH6C0uO5VLL2hWtlGZtXtoyUBwbOJ"];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
#ifdef DEBUG
    put.bucketName = @"meiuitest";
#else
    put.bucketName = @"meiui";
#endif
    put.objectKey = [NSString stringWithFormat:@"upload/user_app/%@", fileName];
//    put.uploadingData = UIImagePNGRepresentation(self.image); // 直接上传NSData
    put.uploadingData = UIImageJPEGRepresentation(self.image, 0.4);
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
//        NSLog(@"当前上传大小%lld, 已经上传总长度%lld, 总长度%lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        printf("当前上传大小%lld, 已经上传总长度%lld, 总长度%lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    __weak typeof(self) weakSelf = self;
    OSSTask *putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSString *imageURL = [NSString stringWithFormat:@"http://%@.%@/%@", put.bucketName, endpoint, put.objectKey];
            [weakSelf upload:imageURL];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"上传失败, error: %@" , task.error]];
        }
        return nil;
    }];
}

- (void)upload:(NSString *)imageURL {
    NSString *url = [NSString stringWithFormat:@"%@?function=User/my_upload&mac=meiui&token=7b41408d1993764335d57232973934de&user_id=%@&pic_url=%@&pic_tag=%@&pic_app=%@&pic_desc=%@", MUIBaseUrl, USER.user_id, imageURL, self.strTags, self.nameValue.text, self.descValue.text];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [MUIHttpTool GET:url params:nil success:^(id json) {
        __weak typeof(self) weakSelf = self;
        if ([json[@"alert"][@"msg"] isEqualToString:@"成功请求"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"上传失败，请检查网络"];
    }];
}

#pragma mark - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // cancel
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameValue) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 32) {
            [SVProgressHUD showErrorWithStatus:@"只能输入32个字符"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 私有方法
- (void)setupSubviews {
    self.navigationItem.title = @"新增作品";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.backScrollView];
    [self.view addSubview:self.publish];
    [self.backView addSubview:self.descValue];
    [self.backView addSubview:self.scrollView];
    [self.scrollView addSubview:self.tagPlaceholder];
    [self.backView addSubview:self.nameValue];
    [self.backView addSubview:self.imageView];
    
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.publish.mas_top);
    }];
    
    [self.backScrollView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backScrollView.mas_top);
        make.left.mas_equalTo(self.backScrollView.mas_left);
        make.right.mas_equalTo(self.backScrollView.mas_right);
        make.width.mas_equalTo(self.backScrollView.mas_width);
    }];
    
    UIImageView *line1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    [self.backView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(10);
        make.top.mas_equalTo(self.backView.mas_top).offset(85 / 2.0);
        make.right.mas_equalTo(self.backView.mas_right).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    UIImageView *line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    [self.backView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_left);
        make.top.mas_equalTo(line1.mas_bottom).offset(85 / 2.0);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(line1.mas_right);
    }];
    
    UILabel *name = [[UILabel alloc] init];
    name.font = [UIFont systemFontOfSize:13];
    name.textColor = RGB(140, 140, 140);
    name.text = @"名称";
    [self.backView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(20);
        make.top.mas_equalTo(self.backView.mas_top);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(line1.mas_top);
    }];
    
    UILabel *tag = [[UILabel alloc] init];
    tag.font = [UIFont systemFontOfSize:13];
    tag.textColor = RGB(140, 140, 140);
    tag.text = @"标签";
    [self.backView addSubview:tag];
    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(name.mas_left);
        make.top.mas_equalTo(line1.mas_bottom);
        make.width.mas_equalTo(name.mas_width);
        make.bottom.mas_equalTo(line2.mas_bottom);
    }];
    
    UILabel *desc = [[UILabel alloc] init];
    desc.font = [UIFont systemFontOfSize:13];
    desc.textColor = RGB(140, 140, 140);
    desc.text = @"描述";
    [self.backView addSubview:desc];
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tag.mas_left);
        make.top.mas_equalTo(line2.mas_bottom);
        make.width.mas_equalTo(tag.mas_width);
        make.height.mas_equalTo(tag.mas_height);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lianjie66"]];
    [self.backView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(line1.mas_right).offset(-10);
        make.centerY.mas_equalTo(tag.mas_centerY);
    }];
    
    [self.descValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(desc.mas_top).offset(5);
        // TextView有边距
        make.left.mas_equalTo(self.nameValue.mas_left).offset(-5);
        make.height.mas_equalTo(80);
        make.right.mas_equalTo(self.imageView.mas_left).offset(-10);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-20);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameValue.mas_left);
        make.top.mas_equalTo(line1.mas_bottom);
        make.bottom.mas_equalTo(line2.mas_top);
        make.right.mas_equalTo(arrow.mas_left).offset(-10);
    }];
    
    [self.tagPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.centerY.mas_equalTo(self.scrollView.mas_centerY);
    }];
    
    [self.nameValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(name.mas_right).offset(10);
        make.top.mas_equalTo(self.backView.mas_top);
        make.right.mas_equalTo(arrow.mas_right);
        make.bottom.mas_equalTo(line1.mas_top);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).offset(10);
        make.right.mas_equalTo(self.backView.mas_right).offset(-10);
        make.top.mas_equalTo(line2.mas_bottom).offset(10);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *warning = [[UILabel alloc] init];
    warning.textColor = RGB(242, 148, 131);
    warning.font = [UIFont systemFontOfSize:14];
    warning.text = @"目前只允许上传iOS的截图呦";
    [self.backScrollView addSubview:warning];
    [warning mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_bottom).offset(11);
        make.centerX.mas_equalTo(self.backScrollView.mas_centerX);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = warning.textColor;
    [self.backScrollView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(warning.mas_left).offset(-10);
        make.centerY.mas_equalTo(warning.mas_centerY);
        make.width.mas_equalTo(50);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = warning.textColor;
    [self.backScrollView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(warning.mas_right).offset(10);
        make.centerY.mas_equalTo(warning.mas_centerY);
        make.width.mas_equalTo(leftLine.mas_width);
    }];
    
    [self.publish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - setter and getter
- (UIScrollView *)backScrollView {
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc] init];
        _backScrollView.alwaysBounceVertical = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [_backScrollView addGestureRecognizer:tap];
        _backScrollView.backgroundColor = RGB(248, 248, 248);
    }
    return _backScrollView;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.imageView.mas_width).multipliedBy(image.size.height / image.size.width);
    }];
    [self.view setNeedsLayout];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UITextField *)nameValue {
    if (_nameValue == nil) {
        _nameValue = [[UITextField alloc] init];
        _nameValue.placeholder = @"该截图所属的APP（必填）";
        _nameValue.font = [UIFont systemFontOfSize:11];
        _nameValue.delegate = self;
        [_nameValue setValue:RGB(210, 210, 210) forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _nameValue;
}

- (MUITextView *)descValue {
    if (_descValue == nil) {
        _descValue = [[MUITextView alloc] init];
        _descValue.font = [UIFont systemFontOfSize:11];
        _descValue.placeholderColor = RGB(210, 210, 210);
        _descValue.placeholder = @"说一些分享的心得（非必填）";
    }
    return _descValue;
}

- (UILabel *)tagPlaceholder {
    if (_tagPlaceholder == nil) {
        _tagPlaceholder = [[UILabel alloc] init];
        _tagPlaceholder.userInteractionEnabled = YES;
        _tagPlaceholder.font = [UIFont systemFontOfSize:11];
        _tagPlaceholder.textColor = RGB(210, 210, 210);
        _tagPlaceholder.text = @"给他合适的定位（至少选一个）";
    }
    return _tagPlaceholder;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTag)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)publish {
    if (_publish == nil) {
        _publish = [[UIButton alloc] init];
        _publish.backgroundColor = RGB(79, 189, 160);
        [_publish setTitle:@"发布" forState:UIControlStateNormal];
        [_publish setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_publish addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publish;
}

@end
