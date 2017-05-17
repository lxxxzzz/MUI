//
//  PhotoGroupViewController.h
//  美UI
//
//  Created by Lee on 17/2/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;
@protocol PhotoGroupViewControllerDelegate <NSObject>

@optional
/**
 *  选择完图片回调
 */
- (void)didSelectPhoto:(Photo *)photo;

@end

@interface PhotoGroupViewController : UIViewController

@property (assign, nonatomic) NSInteger maxSelectionCount;/**< 最多选择图片张数 */
@property (weak, nonatomic) id<PhotoGroupViewControllerDelegate> delegate;
@property (nonatomic, copy) void(^didFinishSelect)();

@end
