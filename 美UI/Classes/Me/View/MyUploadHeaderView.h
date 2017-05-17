//
//  MyUploadHeaderView.h
//  美UI
//
//  Created by Lee on 17/3/15.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyUploadHeaderView, Upload;
@protocol MyUploadHeaderViewDelegate <NSObject>

@optional
- (void)headerViewShowMore:(MyUploadHeaderView *)headerView;

@end

@interface MyUploadHeaderView : UICollectionReusableView

@property (nonatomic, strong) Upload *upload;
@property (nonatomic, weak) id <MyUploadHeaderViewDelegate> delegate;

@end
