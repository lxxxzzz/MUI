//
//  TagView.h
//  美UI
//
//  Created by Lee on 16/9/2.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TagButton, TagView;
typedef enum {
    TagTypeShow,
    TagTypeSingle,
    TagTypeMultiple
}TagType;

@protocol MUITagsViewDelegate <NSObject>
@optional
- (void)tagsView:(TagView *)tagView clickButton:(TagButton *)button selectedItems:(NSArray *)items;

@end

@interface TagView : UIView

/**
 *  类型
 *  默认：TagTypeShow
 *  1、TagTypeShow 显示（不可选择，不可编辑）
 *  2、TagTypeSingle 单选（单选，是否编辑由canEdit属性控制）
 *  3、TagTypeMultiple 多选（多选，是否编辑由canEdit属性控制）
 */
@property (nonatomic, assign) TagType type;

/**
 *  标签的文字
 */
@property (nonatomic, strong) NSMutableArray *tags;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  最大行
 */
@property (nonatomic, assign) int maxRowCount;

/**
 *  文字的字体，字体的颜色和边框一样
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  边框的颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  背景的颜色
 */
@property (nonatomic, strong) UIColor *backColor;

/**
 *  是否可以对tags进行编辑（新增、删除）
 *  默认：NO
 */
@property (nonatomic, assign, getter=isEditable) BOOL editable;

/**
 *  选中的标签
 */
@property (nonatomic, strong) NSMutableArray *selectedTags;

/**
 *  选中标签时调用的block
 */
@property (nonatomic, copy) void (^clickBlock) (NSArray *results);

/**
 *  点击的按钮
 */
@property (nonatomic, copy) void (^clickButton) (TagButton *btn);
/**
 *  按钮的属性
 */
@property (nonatomic, strong) NSMutableDictionary *buttonAtts;
/**
 *  代理
 */
@property (nonatomic, assign) id <MUITagsViewDelegate> tagDelegate;

/**
 *  添加一个标签按钮
 *
 *  @param text 添加标签按钮的文字
 */
- (void)addTag:(NSString *)text;
- (CGFloat)getHeight;

@end
