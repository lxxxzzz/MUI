//
//  MUISegmentControl.m
//  美UI
//
//  Created by Lee on 16-1-5.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUISegmentControl.h"
#import "MUIScrollView.h"

typedef enum {
    MUISegmentedControlTypeText,
    MUISegmentedControlTypeImages
} MUISegmentedControlType;

@interface MUISegmentControl ()

@property (nonatomic, assign) MUISegmentedControlType type;
@property (nonatomic, strong) CALayer *selectionIndicatorStripLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorBoxLayer;
@property (nonatomic, assign) CGFloat segmentWidth;
@property (nonatomic, strong) MUIScrollView *scrollView;

@end



@implementation MUISegmentControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithSectionTitles:(NSArray *)sectiontitles {
    if (self = [self initWithFrame:CGRectZero]) {
        [self commonInit];
        self.sectionTitles = sectiontitles;
        self.type = MUISegmentedControlTypeText;
    }
    return self;
}

- (id)initWithSectionImages:(NSArray*)sectionImages sectionSelectedImages:(NSArray*)sectionSelectedImages {
    if (self = [super initWithFrame:CGRectZero]) {
        [self commonInit];
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
        self.type = MUISegmentedControlTypeImages;
    }
    
    return self;
}

/**
 *  设定初始值
 */
- (void)commonInit {
    self.scrollView = [[MUIScrollView alloc] init];
    // 隐藏垂直、水平滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.font = [UIFont systemFontOfSize:15];
    self.selectedFont = [UIFont boldSystemFontOfSize:15];
    self.textColor = [UIColor blackColor];
    self.selectedTextColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
    self.selectionIndicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    self.type = MUISegmentedControlTypeText;
    self.selectedSegmentIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.selectionIndicatorHeight = 3.0f;
    self.selectionStyle = MUISegmentedControlSelectionStyleFixedWidthStripe;
    self.selectionIndicatorLocation = MUISegmentedControlSelectionIndicatorLocationDown;
    
    self.selectionIndicatorMargin = 70.0f;
    self.selectionIndicatorStripLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer.opacity = 0.2;
    self.selectionIndicatorBoxLayer.borderWidth = 1.0f;
    self.selectionIndicatorColor = [UIColor blackColor];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.type == MUISegmentedControlTypeText && self.sectionTitles) {
        [self updateSegmentsRects];
    } else if (self.type == MUISegmentedControlTypeImages && self.sectionImages) {
        [self updateSegmentsRects];
    }
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    if (self.type == MUISegmentedControlTypeText && self.sectionTitles) {
        [self updateSegmentsRects];
    } else if (self.type == MUISegmentedControlTypeImages && self.sectionImages) {
        [self updateSegmentsRects];
    }
    
    [self setNeedsDisplay];
}

- (void)setSectionTitles:(NSArray *)sectionTitles {
    _sectionTitles = sectionTitles;
    
    [self updateSegmentsRects];
}

- (void)setSectionImages:(NSArray *)sectionImages {
    _sectionImages = sectionImages;
    
    [self updateSegmentsRects];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorBoxLayer.borderColor = self.selectionIndicatorColor.CGColor;
    
    // Remove all sublayers to avoid drawing images over existing ones
    self.scrollView.layer.sublayers = nil;
    
    if (self.type == MUISegmentedControlTypeText) { // 文本类型
        [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
            // 文字的高度
            CGFloat stringHeight = roundf([titleString sizeWithFont:self.font].height);
            // Text inside the CATextLayer will appear blurry unless the rect values are rounded
            CGFloat y = self.frame.size.height * 0.5 -  stringHeight * 0.5;
//            CGFloat y = roundf(((CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2));
            CGRect rect = CGRectMake(self.segmentWidth * idx, y, self.segmentWidth, stringHeight);
            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = rect;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            titleLayer.string = titleString;
            titleLayer.truncationMode = kCATruncationEnd;
            
            if (self.selectedSegmentIndex == idx) {
                titleLayer.foregroundColor = self.selectedTextColor.CGColor;
                titleLayer.font = (__bridge CFTypeRef)(self.selectedFont.fontName);
                titleLayer.fontSize = self.selectedFont.pointSize;
            } else {
                titleLayer.foregroundColor = self.textColor.CGColor;
                titleLayer.font = (__bridge CFTypeRef)(self.font.fontName);
                titleLayer.fontSize = self.font.pointSize;
            }
            
            titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            [self.scrollView.layer addSublayer:titleLayer];
        }];
    } else if (self.type == MUISegmentedControlTypeImages) { // 图片
        [self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
            CGFloat y = ((CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - imageHeight / 2);
            CGFloat x = self.segmentWidth * idx + (self.segmentWidth - imageWidth)/2.0f;
            CGRect rect = CGRectMake(x, y, imageWidth, imageHeight);
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = rect;
            
            if (self.selectedSegmentIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
            } else {
                imageLayer.contents = (id)icon.CGImage;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
        }];
    }

    if (self.selectedSegmentIndex != MUISegmentedControlNoSegment && !self.selectionIndicatorStripLayer.superlayer) {
        self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
        [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
        
        if (self.selectionStyle == MUISegmentedControlSelectionStyleBox && !self.selectionIndicatorBoxLayer.superlayer) {
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
        }
    }
}

/**
 *  指示器的frame
 */
- (CGRect)frameForSelectionIndicator {
    // 指示器的y值
    CGFloat indicatorY = 0.0f;
    
    if (self.selectionIndicatorLocation == MUISegmentedControlSelectionIndicatorLocationDown) { // 指示器在文字下面
        indicatorY = self.bounds.size.height - self.selectionIndicatorHeight;
    }
    
    CGFloat sectionWidth = 0.0f;
    if (self.type == MUISegmentedControlTypeText) {
        sectionWidth = [self.sectionTitles[self.selectedSegmentIndex] sizeWithFont:self.font].width;
    } else if (self.type == MUISegmentedControlTypeImages) {
        UIImage *sectionImage = self.sectionImages[self.selectedSegmentIndex];
        sectionWidth = sectionImage.size.width;
    }
    
    if (self.selectionStyle == MUISegmentedControlSelectionStyleTextWidthStripe && sectionWidth <= self.segmentWidth) { // 指示器的样式设定为宽度和文本宽度一样且宽度大于文本的宽度
        CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedSegmentIndex) + self.segmentWidth;
        CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedSegmentIndex);
        
        CGFloat indicatorX = ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) + (widthToStartOfSelectedIndex - sectionWidth / 2);
        return CGRectMake(indicatorX, indicatorY, sectionWidth, self.selectionIndicatorHeight);
    } else if (self.selectionStyle == MUISegmentedControlSelectionStyleFixedWidthStripe) { // 指示器的样式设定为segmentWidth减去固定间距
        return CGRectMake(self.segmentWidth * self.selectedSegmentIndex + self.selectionIndicatorMargin * 0.5, indicatorY, self.segmentWidth - self.selectionIndicatorMargin, self.selectionIndicatorHeight);
    } else { // 指示器的样式设定为宽度和segmentWidth一样或背景有box
        return CGRectMake(self.segmentWidth * self.selectedSegmentIndex, indicatorY, self.segmentWidth + 20, self.selectionIndicatorHeight);
    }
}

/**
 *  segment的frame
 */
- (CGRect)frameForFillerSelectionIndicator {
    return CGRectMake(self.segmentWidth * self.selectedSegmentIndex, 0, self.segmentWidth, self.frame.size.height);
}

- (void)updateSegmentsRects {
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (self.type == MUISegmentedControlTypeText) {
        self.segmentWidth = self.frame.size.width / self.sectionTitles.count;
    } else if (self.type == MUISegmentedControlTypeImages) {
        self.segmentWidth = self.frame.size.width / self.sectionImages.count;
    }
    
    /**
     *  YES 允许添加更多选项超过屏幕的宽度，segmentWidth的宽度为最大文本/图片宽度
     *  NO 不允许segments的宽度超过屏幕的宽度，segmentWidth的宽度为segments宽度除分段个数
     */
    if (self.isScrollEnabled) {
        if (self.type == MUISegmentedControlTypeText) {
            for (NSString *titleString in self.sectionTitles) {
                CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
                self.segmentWidth = MAX(stringWidth, self.segmentWidth);
            }
        } else if (self.type == MUISegmentedControlTypeImages) {
            for (UIImage *sectionImage in self.sectionImages) {
                CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
                self.segmentWidth = MAX(imageWidth, self.segmentWidth);
            }
        }
    }
    
    if ([self segmentedControlNeedsScrolling]) {
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake([self totalSegmentedControlWidth], self.frame.size.height);
    } else {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.contentSize = self.frame.size;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil) return;
    
    if (self.sectionTitles || self.sectionImages) {
        [self updateSegmentsRects];
    }
}

#pragma mark - Touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
        
        if (segment != self.selectedSegmentIndex) {
            [self setSelectedSegmentIndex:segment animated:YES];
        }
    }
}

#pragma mark - Scrolling
- (BOOL)segmentedControlNeedsScrolling {
    if ([self totalSegmentedControlWidth] > self.frame.size.width && self.isScrollEnabled) {
        return YES;
    }
    return NO;
}

- (CGFloat)totalSegmentedControlWidth {
    if (self.type == MUISegmentedControlTypeText) {
        return self.sectionTitles.count * self.segmentWidth;
    } else {
        return self.sectionImages.count * self.segmentWidth;
    }
}

- (void)scrollToSelectedSegmentIndex {
    CGRect rectForSelectedIndex = CGRectMake(self.segmentWidth * self.selectedSegmentIndex,
                                             0,
                                             self.segmentWidth,
                                             self.frame.size.height);
    
    CGFloat selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);
    CGRect rectToScrollTo = rectForSelectedIndex;
    rectToScrollTo.origin.x -= selectedSegmentOffset;
    rectToScrollTo.size.width += selectedSegmentOffset * 2;
    [self.scrollView scrollRectToVisible:rectToScrollTo animated:YES];
}

#pragma mark - Index change

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [self setSelectedSegmentIndex:index animated:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    _selectedSegmentIndex = index;
    [self setNeedsDisplay];
    
    if (index == MUISegmentedControlNoSegment) {
        [self.selectionIndicatorStripLayer removeFromSuperlayer];
        [self.selectionIndicatorBoxLayer removeFromSuperlayer];
    } else {
        [self scrollToSelectedSegmentIndex];
        
        if (animated) {
            // If the selected segment layer is not added to the super layer, that means no
            // index is currently selected, so add the layer then move it to the new
            // segment index without animating.
            if ([self.selectionIndicatorStripLayer superlayer] == nil) {
                [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
                
                if (self.selectionStyle == MUISegmentedControlSelectionStyleBox && [self.selectionIndicatorBoxLayer superlayer] == nil)
                    [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
                
                [self setSelectedSegmentIndex:index animated:NO ];
                return;
            }
            
            [self notifyForSegmentChangeToIndex:index];
            
            
            // Restore CALayer animations
            self.selectionIndicatorStripLayer.actions = nil;
            self.selectionIndicatorBoxLayer.actions = nil;
            
            // Animate to new position
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.15f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            [CATransaction commit];
        } else {
            // Disable CALayer animations
            NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
            self.selectionIndicatorStripLayer.actions = newActions;
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            
            self.selectionIndicatorBoxLayer.actions = newActions;
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];

            [self notifyForSegmentChangeToIndex:index];
            
        }
    }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    if (self.indexChangeBlock) {
        self.indexChangeBlock(index);
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentControl:indexDidChange:)]) {
        [self.delegate segmentControl:self indexDidChange:index];
    }
}

@end
