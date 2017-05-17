//
//  RightRefresh.h
//  美UI
//
//  Created by Lee on 16/8/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightRefresh : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, copy) void(^operation)();

@end
