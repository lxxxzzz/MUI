//
//  ToolBar.h
//  美UI
//
//  Created by Lee on 17/3/10.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ToolBar;

@protocol ToolBarDelegate <NSObject>

@optional
- (void)toolBar:(ToolBar *)toolBar didClickButton:(UIButton *)btn atIndex:(NSInteger)index;

@end

@interface ToolBar : UIView

@property (nonatomic, weak) id <ToolBarDelegate> delegate;
@property (nonatomic, weak) UIButton *collectButton;

@end
