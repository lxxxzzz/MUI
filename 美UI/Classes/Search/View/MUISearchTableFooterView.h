//
//  MUISearchTableFooterView.h
//  美UI
//
//  Created by Lee on 15-12-25.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTableFooterViewDelegate <NSObject>

@optional

- (void)clearAll;

@end

@interface MUISearchTableFooterView : UIView

@property (nonatomic, weak) id <SearchTableFooterViewDelegate> delegate;

+ (instancetype)searchTableFooter;

@end
