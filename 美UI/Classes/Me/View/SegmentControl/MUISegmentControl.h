//
//  MUISegmentControl.h
//  美UI
//
//  Created by Lee on 16-1-5.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MUISegmentControl;

typedef void (^IndexChangeBlock)(NSInteger index);

typedef enum {
    MUISegmentedControlSelectionStyleTextWidthStripe, // 指示器的宽度和文字的宽度一样
    MUISegmentedControlSelectionStyleFullWidthStripe, // 指示器的宽度和segmentWidth一样
    MUISegmentedControlSelectionStyleFixedWidthStripe, // 指示器固定宽度，宽度是segmentWidth减selectionIndicatorMargin
    MUISegmentedControlSelectionStyleBox //文字背景是一个盒子，指示器的宽度和segmentWidth一样
} MUISegmentedControlSelectionStyle;

typedef enum {
    MUISegmentedControlSelectionIndicatorLocationUp, // 指示器在文字的上面
    MUISegmentedControlSelectionIndicatorLocationDown // 指示器在文字的下面
} MUISegmentedControlSelectionIndicatorLocation;

enum {
    MUISegmentedControlNoSegment = -1   // segment没有选中
};

@protocol MUISegmentControlDelegate <NSObject>

@optional
- (void)segmentControl:(MUISegmentControl *)segmentControl indexDidChange:(NSInteger)index;

@end

@interface MUISegmentControl : UIControl

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *sectionImages;
@property (nonatomic, strong) NSArray *sectionSelectedImages;


/**
 *  segment选项改变时调用的block，也可以使用addTarget:action:forControlEvents:来监听
 */
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

/**
 *  未选中字体
 *  默认[UIFont systemFontOfSize:18]
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  选中时字体
 *  默认[UIFont boldSystemFontOfSize:18]
 */
@property (nonatomic, strong) UIFont *selectedFont;

/**
 *  未选中文字颜色
 *  默认[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  选中时文字颜色
 *  默认[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *selectedTextColor;

/**
 *  背景颜色
 *  默认[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 *  选中时指示器颜色
 *  默认颜色R:52, G:181, B:229
 */
@property (nonatomic, strong) UIColor *selectionIndicatorColor;

/**
 *  segments的样式
 *  默认 MUISegmentedControlSelectionStyleTextWidthStripe 指示器的宽度和文字的宽度一样
 */
@property (nonatomic, assign) MUISegmentedControlSelectionStyle selectionStyle;

/**
 *  指示器位置 
 *  MUISegmentedControlSelectionIndicatorLocationUp 在文字上面
 *  MUISegmentedControlSelectionIndicatorLocationDown 在文字下面
 */
@property (nonatomic, assign) MUISegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;

/**
 *  YES 允许添加更多选项超过屏幕的宽度，segmentWidth的宽度为最大文本/图片宽度
 *  NO 不允许segments的宽度超过屏幕的宽度，segmentWidth的宽度为segments宽度除分段个数
 *  默认为 NO
 */
@property(nonatomic, getter = isScrollEnabled) BOOL scrollEnabled;

/**
 *  选中时的index
 *  默认选中第0个
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/**
 *  指示器的高度
 *  默认5.0
 */
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight;

/**
 *  指示器的间距
 *  默认为0
 */
@property (nonatomic, readwrite) CGFloat selectionIndicatorMargin;

/**
 *  segments左右滚动的区域，只有scrollEnabled为YES时有效
 *  默认UIEdgeInsetsMake(0, 5, 0, 5)
 */
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;

@property (nonatomic, weak) id <MUISegmentControlDelegate> delegate;

- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (id)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setIndexChangeBlock:(IndexChangeBlock)indexChangeBlock;

@end
