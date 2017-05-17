//
//  MUIFeedbackViewController.m
//  美UI
//
//  Created by Lee on 16-3-17.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIFeedbackViewController.h"
#import "MUIPlaceholderTextView.h"
#import "MUIFeedbackSuccessView.h"
#import "AFNetworking.h"
#import "MUIHttpTool.h"
#import "MUIHttpParams.h"
#import "User.h"
#import "SVProgressHUD.h"

@interface MUIFeedbackViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MUIPlaceholderTextView *feedback;
@property (nonatomic, strong) UIBarButtonItem *confirmButton;

@end

@implementation MUIFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    self.feedback.placeholder = @"请简单描述你遇到的问题";
    [self.feedback becomeFirstResponder];
    
    [MUINotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = self.confirmButton;
}

- (UIBarButtonItem *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
        _confirmButton.enabled = NO;
    }
    return _confirmButton;
}

- (void)textDidChange {
    self.confirmButton.enabled = self.feedback.hasText;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)submit {
    NSMutableDictionary *params = [MUIHttpParams feedbackParams];
    params[@"msg"] = self.feedback.text;
    [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success)
        {
            [self.view endEditing:YES];
            MUIFeedbackSuccessView *success = [MUIFeedbackSuccessView successView];
            success.frame = self.view.bounds;
            self.navigationItem.rightBarButtonItem = nil;
            [self.view addSubview:success];
        }
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"网络有问题，请稍后再试！"];
    }];
}

- (void)dealloc {
    [MUINotificationCenter removeObserver:self];
}

@end
