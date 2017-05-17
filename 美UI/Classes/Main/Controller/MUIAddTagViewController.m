//
//  MUIAddTagViewController.m
//  美UI
//
//  Created by Lee on 16-4-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIAddTagViewController.h"
#import "NSString+MUIExtension.h"
#import "TagButton.h"
#import "MUITagTextField.h"
#import "MUIHttpTool.h"
#import "MUIHttpParams.h"
#import "SVProgressHUD.h"
#import "User.h"
#import "TagView.h"
#import "MUICacheTool.h"
#import "UIBarButtonItem+MUIExtension.h"
#import <Masonry.h>

#define kMargin 10
#define kMinWidth 70
#define kMaxWidth SCREEN_WIDTH - 2 * kMargin

@interface MUIAddTagViewController () <UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate, MUITagsViewDelegate>
{
    BOOL _edit;
    NSMutableDictionary *_buttonAtts;
}

/**按钮编辑文本框 */
@property (nonatomic, strong) MUITagTextField *textField;
/**标签按钮数组 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
/**编辑标签的背景View */
@property (nonatomic, strong) UIView *backView;
/**选中的按钮 */
@property (nonatomic, strong) TagButton *selectedBtn;
/**背景View */
@property (nonatomic, strong) UIScrollView *scrollView;
/**推荐标签 */
@property (nonatomic, strong) TagView *tagsView;
/**我的标签 */
@property (nonatomic, strong) TagView *myTagsView;
@property (nonatomic, strong) UIBarButtonItem *confirmButton;

@end

@implementation MUIAddTagViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self setupNavigationItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [UIApplication sharedApplication].statusBarHidden = YES;
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), SCREEN_WIDTH, 600);
//}

- (void)textFieldDidDeleteText {
    if (!self.textField.hasText) {
        // 已经删到最后一个文字
        TagButton *tag = [self.tagButtons lastObject];
        if (self.selectedBtn.selected) {
            // 如果有选中的文字，优先删除选中的
            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
            [self deleteButton:self.selectedBtn];
        } else {
            if (!tag.selected) {
                // 将要删除的button的selected设置为YES，并更新selectedBtn的值
                tag.selected = YES;
                self.selectedBtn = tag;
            } else {
                [self deleteButton:tag];
            }
        }
    } else {
        // 删除文字时，隐藏menu并取消选中button
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        self.selectedBtn.selected = NO;
    }
}

- (void)back {
    [self.view endEditing:YES];
    if (_edit) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否放弃编辑？" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续", nil];
        [alert show];
    } else {
        if (self.backEvent) {
            self.backEvent();
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)done {
    [self.view endEditing:YES];
    // 添加button
    [self addTag];
    
    // 发送网络请求
    [self createTags];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"编辑标签";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = self.confirmButton;
    self.view.backgroundColor = BG_COLOR;
}

- (void)setupTag {
    if (self.myTags.count) {
        for (NSString *text in self.myTags) {
            self.textField.text = text;
            [self addTag];
        }
        self.myTags = nil;
    }
}

- (void)addTag {
    if (self.textField.hasText) {
        NSArray *allTag = [self.tagButtons valueForKeyPath:@"currentTitle"];
        if ([allTag containsObject:self.textField.text]) {
            // 标签已经存在，就先删除然后再新建一个
            [self deleteButton:[self tagWithTitle:self.textField.text]];
        }
        TagButton *tag = [TagButton buttonWithTitle:self.textField.text target:self action:@selector(buttonClick:)];
        [self.backView addSubview:tag];
        [self.tagButtons addObject:tag];
        // 清除文本框
        self.textField.text = nil;
        [self updateTagButtonFrame];
        [self textChange];
        
        self.tagsView.selectedTags = [self.tagButtons valueForKeyPath:@"currentTitle"];
        self.myTagsView.selectedTags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    }
}

- (void)textChange {
    [self updateTextFieldFrame];
    
    // 文字发生改变时，隐藏menu并取消选中button
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    self.selectedBtn.selected = NO;
    
    if (self.textField.hasText) {
        _edit = YES;
        self.textField.showBorder = YES;
    } else {
        self.textField.showBorder = NO;
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (CGFloat)textFieldWidth {
    CGFloat w = [self.textField.text sizeWithText:CGSizeMake(MAXFLOAT, 25) font:self.textField.font].width + 20;
    return MIN(MAX(kMinWidth, w), kMaxWidth);
}

- (void)updateTagButtonFrame {
    for (int i = 0; i < self.tagButtons.count; i++) {
        TagButton *tag = self.tagButtons[i];
        if (i == 0) {
            // 第一个按钮
            tag.x = kMargin;
            tag.y = kMargin;
        } else {
            // 其他按钮
            TagButton *lastTag = self.tagButtons[i - 1];
            CGFloat leftWidth = CGRectGetMaxX(lastTag.frame) + kMargin;
            CGFloat rightWidth = self.backView.width - leftWidth;
            if (rightWidth >= tag.width) {
                // 空间够，直接放在后面
                tag.x = CGRectGetMaxX(lastTag.frame) + kMargin;
                tag.y = lastTag.y;
            } else {
                // 空间不够，放到下一行
                tag.x = kMargin;
                tag.y = CGRectGetMaxY(lastTag.frame) + kMargin;
            }
        }
    }
}

- (void)updateTextFieldFrame {
    TagButton *lastBtn = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastBtn.frame) + kMargin;
    CGFloat rightWidth = self.backView.width - leftWidth;
    self.textField.width = [self textFieldWidth];
    if (rightWidth < self.textField.width) {
        self.textField.x = kMargin;
        self.textField.y = CGRectGetMaxY(lastBtn.frame) + kMargin;
    } else {
        self.textField.x = CGRectGetMaxX(lastBtn.frame) + kMargin;
        self.textField.y = lastBtn ? lastBtn.y : kMargin;
    }
    
    self.backView.height = MAX((CGRectGetMaxY(self.textField.frame) + kMargin), 48);
}

- (void)buttonClick:(TagButton *)btn {
    self.selectedBtn = btn;
    btn.selected = !btn.selected;
    for (TagButton *btn in self.tagButtons) {
        if (btn != self.selectedBtn) {
            btn.selected = NO;
        }
    }
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (btn.selected) {
        UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItem:)];
        [btn becomeFirstResponder];
        menu.menuItems = @[delete];
        [menu setTargetRect:btn.frame inView:btn.superview];
        [menu setMenuVisible:YES animated:YES];
    } else {
        [menu setMenuVisible:NO animated:YES];
    }
}

- (void)deleteItem:(UIMenuController *)menu {
    [self deleteButton:self.selectedBtn];
}

- (void)deleteButton:(TagButton *)btn {
    if (self.selectedBtn == btn) {
        // 如果选中的按钮被删除的话，指针指向空
        self.selectedBtn = nil;
    }
    
    [btn removeFromSuperview];
    [self.tagButtons removeObject:btn];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.tagsView.selectedTags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    self.myTagsView.selectedTags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textField.hasText) {
        [self addTag];
    } else {
        [self.textField shake];
    }
    
    return YES;
}

- (void)createTags {
    NSMutableDictionary *params = [MUIHttpParams createTagParams];
    NSArray *titles = [self.tagButtons valueForKeyPath:@"currentTitle"];
    if ([User isOnline]) {
        params[@"user_id"] = [User sharedUser].user_id;
    }
    params[@"tag_name"] = [self strWithArray:titles];
    params[@"pic_id"] = self.pic_id;
    [MUIHttpTool GET:MUIBaseUrl params:params success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            [SVProgressHUD showSuccessWithStatus:@"已保存"];
            // 将新添加的tag缓存到数据库
            [MUICacheTool addTags:[self.tagButtons valueForKeyPath:@"currentTitle"]];

            if (self.finishBlock) self.finishBlock(titles);
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    } failure:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }];
}

- (NSString *)strWithArray:(NSArray *)arr {
    NSString *string = nil;
    for (NSString *str in arr) {
        if (string) {
            string = [NSString stringWithFormat:@"%@,%@",string, str];
        } else {
            string = str;
        }
    }
    return string;
}

- (TagButton *)tagWithTitle:(NSString *)title {
    for (TagButton *tag in self.tagButtons) {
        if ([tag.currentTitle isEqualToString:title]) {
            return tag;
        }
    }
    return nil;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        // 文字发生改变时，隐藏menu并取消选中button
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        self.selectedBtn.selected = NO;
        [self.textField resignFirstResponder];
    }
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.view endEditing:YES];
        if (self.backEvent) {
            self.backEvent();
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - <MUITagsViewDelegate>
- (void)tagsView:(TagView *)tagView clickButton:(TagButton *)button selectedItems:(NSArray *)items {
    if (button.selected) {
        self.textField.text = [button currentTitle];
        [self addTag];
    } else {
        [self deleteButton:[self tagWithTitle:button.currentTitle]];
    }
}

#pragma mark - layout
- (void)setupSubviews {
    [self.view addSubview:self.backView];
    
    [self.backView addSubview:self.textField];
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.tagsView];
    
    [self.scrollView addSubview:self.myTagsView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.backView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.scrollView.mas_top).offset(10);
        make.height.mas_equalTo(100);
    }];
    
    [self.myTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.tagsView.mas_bottom);
        make.height.mas_equalTo(300);
    }];
}

#pragma mark - setter and getter
#pragma mark setter
- (void)setMyTags:(NSArray *)myTags {
    _myTags = myTags;
    
    if (myTags.count) {
        for (NSString *text in myTags) {
            self.textField.text = text;
            [self addTag];
        }
//        self.myTags = nil;
    }
    
    [self.view setNeedsDisplay];
}

- (void)setRecommendTag:(NSArray *)recommendTag {
    _recommendTag = recommendTag;
    
    self.tagsView.tags = [NSMutableArray arrayWithArray:recommendTag];
    
    [self.tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.recommendTag.count == 0) {
            make.height.mas_equalTo(0);
        }
    }];
}

- (void)setMyAllTags:(NSArray *)myAllTags {
    _myAllTags = myAllTags;
    
    self.myTagsView.tags = [NSMutableArray arrayWithArray:myAllTags];
}

- (void)setButtonAtts:(NSMutableDictionary *)buttonAtts {
    _buttonAtts = buttonAtts;
    
    self.myTagsView.buttonAtts = buttonAtts;
    self.tagsView.buttonAtts = buttonAtts;
}

#pragma mark getter
- (NSMutableArray *)tagButtons {
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (TagView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[TagView alloc] init];
        _tagsView.title = @"推荐标签";
        _tagsView.type = TagTypeMultiple;
        _tagsView.tagDelegate = self;
    }
    return _tagsView;
}

- (TagView *)myTagsView {
    if (!_myTagsView) {
        _myTagsView = [[TagView alloc] init];
        _myTagsView.title = @"我的标签";
        _myTagsView.type = TagTypeMultiple;
        _myTagsView.tagDelegate = self;
    }
    return _myTagsView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
    }
    return _backView;
}

- (MUITagTextField *)textField {
    if (!_textField) {
        _textField = [MUITagTextField textWithTarget:self action:@selector(textChange)];
        _textField.x = 10;
        _textField.y = 10;
        _textField.width = kMinWidth;
        _textField.delegate = self;
        __weak typeof(self) weakSelf = self;
        _textField.deleteBlock = ^{
            [weakSelf textFieldDidDeleteText];
        };
    }
    return _textField;
}

- (UIBarButtonItem *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIBarButtonItem itemWithTitle:@"完成" target:self action:@selector(done)];
        _confirmButton.enabled = NO;
    }
    return _confirmButton;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
